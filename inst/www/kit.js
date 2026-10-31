/* kitDesign：KIT Shiny app 的瀏覽器端小程式
 *
 * 合併了 kitJoin 的 kit_app_js() 與 kitsUI 的 kit_tabs_js()、kit_js()：
 *  1. 收合區塊（<details>）打開或收起時，通知 Shiny 裡面的 output 看不看得到
 *     （收起來時暫停的 output 打開後才會畫）；打開時讓圖重新量大小。
 *  2. 分組分頁列（kit_navgroups()）：按下去時切換藏起來的 tabsetPanel；
 *     分頁換了以後（包括 updateTabsetPanel()）把目前的分頁標成 active。
 *  3. 有順序的流程分頁（kit_flow_tabs(aside = )）：不是流程一步的分頁加上 .kit-tab-aside。
 *  4. kit-tab-states：伺服器算好的分頁狀態（kit_send_tab_states()），替兩種分頁列的連結
 *     加上 class 與滑過時的說明：kit-tab-done 打 ✓、kit-tab-locked 灰色、kit-tab-stale 拿掉 ✓。
 *  5. kit-open-details：打開指定 id 的收合區塊（kit_open_details()）。
 *  6. kit-scroll：把指定 id 的元素捲到畫面上方（kit_scroll_to()）；
 *     使用者設定「減少動態效果」時直接跳過去。
 *  7. kit-unload-guard：有結果時，關掉或重新整理分頁前先問一次（kit_unload_guard()）。
 *  8. 「複製」按鈕（.kit-copy）：複製下一個元素（程式碼框）的文字，按了顯示「已複製」1.5 秒。
 */
(function() {
  var $ = window.jQuery;

  // 1. 收合區塊
  document.addEventListener('toggle', function(e) {
    var d = e.target;
    if (!d || d.tagName !== 'DETAILS' || !$) return;
    $(d).trigger(d.open ? 'shown' : 'hidden');
    if (d.open) window.dispatchEvent(new Event('resize'));
  }, true);

  function cssEscape(s) {
    return String(s).replace(/["\\]/g, '\\$&');
  }
  // 分組分頁列的連結（tabset = tabsetPanel 的 id）
  function groupLinks(tabset, value) {
    var sel = '.kit-navgroups[data-tabset="' + cssEscape(tabset) + '"] a[data-kit-tab' +
      (value ? '="' + cssEscape(value) + '"' : '') + ']';
    return Array.prototype.slice.call(document.querySelectorAll(sel));
  }
  // 流程分頁列（看得到的 tabsetPanel）的連結
  function flowLinks(tabset, value) {
    var ul = document.getElementById(tabset);
    if (!ul || ul.classList.contains('nav-hidden')) return [];
    var sel = 'a[data-value="' + cssEscape(value) + '"]';
    return Array.prototype.slice.call(ul.querySelectorAll(sel));
  }

  // 3. 流程分頁：不是流程一步的分頁
  function markAside() {
    document.querySelectorAll('.kit-flow-tabs[data-kit-aside]').forEach(function(box) {
      var values = (box.getAttribute('data-kit-aside') || '').split('|').filter(Boolean);
      var first = true;
      values.forEach(function(v) {
        box.querySelectorAll('ul.nav a[data-value="' + cssEscape(v) + '"]').forEach(function(a) {
          if (a.closest('.kit-flow-tabs') !== box) return;
          a.classList.add('kit-tab-aside');
          var li = a.closest('li');
          if (li && first) li.classList.add('kit-tab-aside-first');
          first = false;
        });
      });
    });
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', markAside);
  } else {
    markAside();
  }

  if ($) {
    // 2. 分組分頁列
    $(document).on('click', '.kit-navgroups a[data-kit-tab]', function(e) {
      e.preventDefault();
      var bar = this.closest('.kit-navgroups');
      var ul = document.getElementById(bar.getAttribute('data-tabset'));
      if (!ul) return;
      var tab = ul.querySelector('a[data-value="' + cssEscape(this.getAttribute('data-kit-tab')) + '"]');
      if (tab) $(tab).tab('show');
    });
    $(document).on('shown.bs.tab', 'ul.shiny-tab-input a[data-value]', function() {
      var ul = this.closest('ul'), value = this.getAttribute('data-value');
      if (!ul || !ul.id) return;
      groupLinks(ul.id).forEach(function(a) {
        var on = a.getAttribute('data-kit-tab') === value;
        a.classList.toggle('active', on);
        if (on) a.setAttribute('aria-current', 'page'); else a.removeAttribute('aria-current');
      });
    });

    // 8. 複製
    $(document).on('click', '.kit-copy', function() {
      var b = this, target = b.parentElement && b.parentElement.nextElementSibling;
      if (!target || !navigator.clipboard) return;
      navigator.clipboard.writeText(target.innerText).then(function() {
        b.textContent = '已複製';
        setTimeout(function() { b.textContent = '複製'; }, 1500);
      });
    });
  }

  // 7. 離開頁面前的提醒
  // Firefox 按下載連結（<a download>）時也會觸發 beforeunload：使用者按「離開」後頁面真的離開、
  // 連線斷掉，下載網址就是 Not Found。Firefox 在伺服器開始回傳檔案時才觸發，圖檔（pandoc 打包）
  // 要好幾秒，所以按下載後不提醒，直到使用者回到這一頁（focus）或過了 2 分鐘。
  // Chrome、Safari 本來就不會觸發。
  var guard = false;
  var downloading = 0;
  document.addEventListener('click', function(e) {
    var a = e.target && e.target.closest ? e.target.closest('a[download]') : null;
    if (a) downloading = Date.now();
  }, true);
  window.addEventListener('focus', function() {
    // 下載對話框關掉、回到頁面：恢復提醒（點下載的同一刻也會 focus，所以至少等 1 秒）
    if (downloading && Date.now() - downloading > 1000) downloading = 0;
  });
  window.addEventListener('beforeunload', function(e) {
    if (!guard) return;
    if (downloading && Date.now() - downloading < 120000) return;
    e.preventDefault();
    e.returnValue = '';
  });

  // 4. 分頁狀態
  function applyTabState(s) {
    var links = groupLinks(s.tabset, s.value).concat(flowLinks(s.tabset, s.value));
    links.forEach(function(a) {
      a.classList.remove('kit-tab-done', 'kit-tab-locked', 'kit-tab-stale');
      if (s.state && s.state !== 'ready') a.classList.add('kit-tab-' + s.state);
      if (s.tip) {
        a.setAttribute('title', s.tip);
        a.setAttribute('aria-description', s.tip);
      } else {
        a.removeAttribute('title');
        a.removeAttribute('aria-description');
      }
      // 看不見的「（已完成）」：分組分頁的 ✓ 是 CSS 畫的，流程分頁的 ✓ 是 .kit-tab-mark
      var sr = a.querySelector('.kit-tab-sr');
      if (s.state === 'done' && !sr) {
        sr = document.createElement('span');
        sr.className = 'visually-hidden kit-tab-sr';
        sr.textContent = '（已完成）';
        a.appendChild(sr);
      }
      if (s.state !== 'done' && sr) sr.remove();
      if (a.closest('.kit-navgroups')) return;
      var mark = a.querySelector('.kit-tab-mark');
      if (s.state === 'done' && !mark) {
        mark = document.createElement('span');
        mark.className = 'kit-tab-mark';
        mark.setAttribute('aria-hidden', 'true');
        mark.textContent = '✓';
        a.insertBefore(mark, a.querySelector('.kit-tab-sr'));
      }
      if (s.state !== 'done' && mark) mark.remove();
    });
  }

  var registered = false;
  function register() {
    if (registered || !window.Shiny || !Shiny.addCustomMessageHandler) return;
    registered = true;
    Shiny.addCustomMessageHandler('kit-tab-states', function(states) {
      if (!Array.isArray(states)) states = [states];
      states.forEach(applyTabState);
    });
    Shiny.addCustomMessageHandler('kit-open-details', function(id) {
      var d = document.getElementById(id);
      if (d) d.open = true;
    });
    Shiny.addCustomMessageHandler('kit-scroll', function(id) {
      var el = document.getElementById(id);
      // uiOutput 的 div 是 display: contents（沒有框），要捲到裡面第一個真的元素（狀態框）
      while (el && getComputedStyle(el).display === 'contents') el = el.firstElementChild;
      if (!el || !el.scrollIntoView) return;
      var reduce = window.matchMedia &&
        window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      el.scrollIntoView({block: 'start', behavior: reduce ? 'auto' : 'smooth'});
    });
    Shiny.addCustomMessageHandler('kit-unload-guard', function(on) { guard = !!on; });
  }
  register();
  if ($) {
    $(document).on('shiny:connected', register);
    $(document).on('shiny:disconnected', function() { guard = false; });
  }
})();
