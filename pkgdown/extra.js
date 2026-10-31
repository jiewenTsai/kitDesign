// 語言切換：導覽列的「English／中文」連到另一個語言的同一頁（沒有的話就是首頁）。
// 英文網站在根目錄，中文網站在 zh/；兩邊的頁面路徑一樣。
document.addEventListener("DOMContentLoaded", () => {
  const brand = document.querySelector("a.navbar-brand");
  if (!brand) return;
  const myRoot = new URL(".", brand.href).href;
  document.querySelectorAll(".navbar a.nav-link").forEach((a) => {
    const text = a.textContent.trim();
    if (text !== "English" && text !== "中文") return;
    const otherRoot = new URL(".", a.href).href;
    const page = location.href.slice(myRoot.length);
    a.href = otherRoot + page;
    a.setAttribute("lang", text === "English" ? "en" : "zh-TW");
  });
});
