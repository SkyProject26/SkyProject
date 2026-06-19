/**
 * Sora UI
 * ------------------------------------------------------------
 * 使い方:
 *   1. index.html に <script src="sora-ui.js"></script> を置く
 *   2. UIを表示したい場所に
 *        <div id="app" data-soraui-src="page.soraui"></div>
 *      と書く
 *   3. page.soraui (JSON) に theme / tabs / components を書く
 *
 * このファイルは編集不要です。
 * UIの追加・変更はすべて .soraui ファイル側で行います。
 * ------------------------------------------------------------
 */

(function () {
  "use strict";

  /* ============================================================
   * 1. テーマ定義
   *    新しいテーマを増やしたい場合はここに追加する
   *    （.sorauiファイルの "theme" で名前を指定して使う）
   * ============================================================ */
  const THEMES = {
    OrangeDark: {
      primary: "#ff8c42",
      primaryHover: "#ff7a1f",
      bg: "#1a1410",
      surface: "#241c16",
      border: "#3a2c20",
      text: "#f5e8dc",
      textMuted: "#caa98f",
    },
    OrangeLight: {
      primary: "#ff8c42",
      primaryHover: "#e6741f",
      bg: "#fff8f0",
      surface: "#ffffff",
      border: "#f0ddc8",
      text: "#2d2424",
      textMuted: "#8a7565",
    },
  };

  const DEFAULT_THEME = "OrangeLight";

  /* ============================================================
   * 2. スタイル注入
   *    CSSファイルを使わず、JSの中からstyleタグを生成する
   * ============================================================ */
  function injectStyles(themeName) {
    const theme = THEMES[themeName] || THEMES[DEFAULT_THEME];

    const cssVars = Object.entries(theme)
      .map(([key, value]) => `--ui-${key}: ${value};`)
      .join("\n      ");

    const css = `
      :root {
        ${cssVars}
      }

      .ui-root {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Hiragino Sans, sans-serif;
        background: var(--ui-bg);
        color: var(--ui-text);
        min-height: 100%;
        padding: 24px;
        box-sizing: border-box;
      }

      /* ---- Tab ---- */
      .ui-tabbar {
        display: flex;
        gap: 4px;
        border-bottom: 1px solid var(--ui-border);
        margin-bottom: 20px;
      }

      .ui-tabbar-item {
        padding: 10px 18px;
        cursor: pointer;
        color: var(--ui-textMuted);
        border-bottom: 2px solid transparent;
        font-size: 14px;
        font-weight: 600;
        transition: color 0.15s ease, border-color 0.15s ease;
        user-select: none;
      }

      .ui-tabbar-item:hover {
        color: var(--ui-text);
      }

      .ui-tabbar-item.is-active {
        color: var(--ui-primary);
        border-bottom-color: var(--ui-primary);
      }

      .ui-tabpanel {
        display: none;
      }

      .ui-tabpanel.is-active {
        display: block;
      }

      /* ---- Section ---- */
      .ui-section {
        background: var(--ui-surface);
        border: 1px solid var(--ui-border);
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 16px;
      }

      .ui-section-title {
        font-size: 15px;
        font-weight: 700;
        margin: 0 0 14px 0;
        color: var(--ui-text);
      }

      .ui-section-body {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
      }

      /* ---- Button ---- */
      .ui-button {
        appearance: none;
        border: none;
        border-radius: 8px;
        padding: 10px 18px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: background 0.15s ease, transform 0.05s ease;
      }

      .ui-button:active {
        transform: scale(0.98);
      }

      .ui-button--primary {
        background: var(--ui-primary);
        color: #ffffff;
      }

      .ui-button--primary:hover {
        background: var(--ui-primaryHover);
      }

      .ui-button--secondary {
        background: transparent;
        color: var(--ui-text);
        border: 1px solid var(--ui-border);
      }

      .ui-button--secondary:hover {
        background: var(--ui-border);
      }

      .ui-error {
        color: #d64545;
        font-family: monospace;
        white-space: pre-wrap;
        padding: 16px;
        border: 1px solid #d64545;
        border-radius: 8px;
      }

      /* ---- Docs mode ---- */
      .ui-docs {
        display: flex;
        align-items: flex-start;
        gap: 0;
        padding: 0;
      }

      .ui-docs-sidebar {
        width: 240px;
        flex-shrink: 0;
        background: var(--ui-surface);
        border-right: 1px solid var(--ui-border);
        padding: 20px 12px;
        min-height: 100vh;
        box-sizing: border-box;
      }

      .ui-docs-content {
        flex: 1;
        padding: 32px 40px;
        min-width: 0;
      }

      .ui-docs-category {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        font-weight: 700;
        color: var(--ui-textMuted);
        padding: 6px 10px;
        margin: 16px 0 4px;
        text-transform: uppercase;
        letter-spacing: 0.03em;
      }

      .ui-docs-category:first-child {
        margin-top: 0;
      }

      .ui-docs-icon {
        width: 16px;
        height: 16px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        flex-shrink: 0;
      }

      .ui-docs-icon img {
        width: 16px;
        height: 16px;
        object-fit: contain;
      }

      .ui-docs-page {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: var(--ui-text);
        padding: 8px 10px 8px 26px;
        border-radius: 6px;
        cursor: pointer;
        user-select: none;
        transition: background 0.12s ease, color 0.12s ease;
      }

      .ui-docs-page:hover {
        background: var(--ui-border);
      }

      .ui-docs-page.is-active {
        background: var(--ui-primary);
        color: #ffffff;
        font-weight: 600;
      }

      .ui-docs-panel {
        display: none;
      }

      .ui-docs-panel.is-active {
        display: block;
      }

      .ui-docs-panel-title {
        font-size: 24px;
        font-weight: 700;
        margin: 0 0 20px 0;
        color: var(--ui-text);
      }
    `;

    const styleTag = document.createElement("style");
    styleTag.setAttribute("data-sora-ui", "true");
    styleTag.textContent = css;
    document.head.appendChild(styleTag);
  }

  /* ============================================================
   * 3. コンポーネント生成（JSON -> DOM）
   * ============================================================ */

  // icon文字列が画像URLっぽいかどうかを判定して、適切な要素を作る
  // 例: "icon.svg", "https://.../icon.png" -> <img>
  //     "📘", "API" のような短い文字列 -> そのままテキスト
  function createIconElement(icon) {
    if (!icon) return null;

    const looksLikeImage = /\.(svg|png|jpe?g|gif|webp)$/i.test(icon) || /^https?:\/\//.test(icon);

    const span = document.createElement("span");
    span.className = "ui-docs-icon";

    if (looksLikeImage) {
      const img = document.createElement("img");
      img.src = icon;
      img.alt = "";
      span.appendChild(img);
    } else {
      span.textContent = icon;
    }

    return span;
  }

  // type: "button" の要素を作る
  function createButton(def) {
    const variant = def.color === "secondary" ? "secondary" : "primary";
    const action = def.action || {};

    let el;
    if (action.type === "link" && action.url) {
      el = document.createElement("a");
      el.href = action.url;
      if (action.target) el.target = action.target;
    } else {
      el = document.createElement("button");
      el.type = "button";
    }

    el.className = `ui-button ui-button--${variant}`;
    el.textContent = def.title || "";
    return el;
  }

  // type: "section" の要素を作る（children を再帰的に描画）
  function createSection(def) {
    const wrap = document.createElement("section");
    wrap.className = "ui-section";

    if (def.title) {
      const h = document.createElement("h3");
      h.className = "ui-section-title";
      h.textContent = def.title;
      wrap.appendChild(h);
    }

    const body = document.createElement("div");
    body.className = "ui-section-body";

    (def.children || []).forEach((child) => {
      const childEl = createComponent(child);
      if (childEl) body.appendChild(childEl);
    });

    wrap.appendChild(body);
    return wrap;
  }

  // type に応じて生成関数を振り分ける
  function createComponent(def) {
    switch (def.type) {
      case "button":
        return createButton(def);
      case "section":
        return createSection(def);
      default:
        console.warn(`[Sora UI] unknown component type: "${def.type}"`);
        return null;
    }
  }

  /* ============================================================
   * 4. タブの描画
   *    tabs定義からタブバーを作り、componentsをtabIdごとに振り分けて
   *    タブパネルとして配置する
   * ============================================================ */
  function renderTabs(root, data) {
    const tabs = data.tabs || [];
    const components = data.components || [];

    // タブが定義されていない場合は、componentsをそのまま流し込むだけ
    if (tabs.length === 0) {
      components.forEach((c) => {
        const el = createComponent(c);
        if (el) root.appendChild(el);
      });
      return;
    }

    const tabbar = document.createElement("div");
    tabbar.className = "ui-tabbar";

    const panels = {};

    tabs.forEach((tab, index) => {
      // タブボタン
      const tabItem = document.createElement("div");
      tabItem.className = "ui-tabbar-item" + (index === 0 ? " is-active" : "");
      tabItem.textContent = tab.title || tab.id;
      tabItem.dataset.tabId = tab.id;

      tabItem.addEventListener("click", () => {
        // 全部のタブ/パネルを非アクティブにしてから、押されたものだけアクティブに
        tabbar.querySelectorAll(".ui-tabbar-item").forEach((el) => el.classList.remove("is-active"));
        Object.values(panels).forEach((panel) => panel.classList.remove("is-active"));

        tabItem.classList.add("is-active");
        if (panels[tab.id]) panels[tab.id].classList.add("is-active");
      });

      tabbar.appendChild(tabItem);

      // タブパネル（このタブに属するcomponentsの入れ物）
      const panel = document.createElement("div");
      panel.className = "ui-tabpanel" + (index === 0 ? " is-active" : "");
      panel.dataset.tabId = tab.id;
      panels[tab.id] = panel;
    });

    root.appendChild(tabbar);
    Object.values(panels).forEach((panel) => root.appendChild(panel));

    // componentsを、それぞれの tab プロパティが指すパネルに振り分ける
    components.forEach((c) => {
      const el = createComponent(c);
      if (!el) return;

      const targetPanel = c.tab && panels[c.tab] ? panels[c.tab] : panels[tabs[0].id];
      targetPanel.appendChild(el);
    });
  }

  /* ============================================================
   * 4.5 Docsモードの描画
   *    sidebar定義から「カテゴリ -> ページ」の1階層サイドバーを作り、
   *    componentsをpage idごとに振り分けて右側に表示する
   * ============================================================ */
  function renderDocs(root, data) {
    const sidebarDef = data.sidebar || [];
    const components = data.components || [];

    root.classList.add("ui-docs");

    const sidebar = document.createElement("nav");
    sidebar.className = "ui-docs-sidebar";

    const content = document.createElement("div");
    content.className = "ui-docs-content";

    const panels = {};
    let firstPageId = null;

    sidebarDef.forEach((category) => {
      // カテゴリ見出し
      const catEl = document.createElement("div");
      catEl.className = "ui-docs-category";

      const catIcon = createIconElement(category.icon);
      if (catIcon) catEl.appendChild(catIcon);

      const catLabel = document.createElement("span");
      catLabel.textContent = category.title || category.id;
      catEl.appendChild(catLabel);

      sidebar.appendChild(catEl);

      // カテゴリ内の各ページ
      (category.pages || []).forEach((page) => {
        if (!firstPageId) firstPageId = page.id;

        const pageEl = document.createElement("div");
        pageEl.className = "ui-docs-page";
        pageEl.dataset.pageId = page.id;

        const pageIcon = createIconElement(page.icon);
        if (pageIcon) pageEl.appendChild(pageIcon);

        const pageLabel = document.createElement("span");
        pageLabel.textContent = page.title || page.id;
        pageEl.appendChild(pageLabel);

        pageEl.addEventListener("click", () => {
          sidebar.querySelectorAll(".ui-docs-page").forEach((el) => el.classList.remove("is-active"));
          Object.values(panels).forEach((panel) => panel.classList.remove("is-active"));

          pageEl.classList.add("is-active");
          if (panels[page.id]) panels[page.id].classList.add("is-active");
        });

        sidebar.appendChild(pageEl);

        // このページ用のコンテンツパネル
        const panel = document.createElement("div");
        panel.className = "ui-docs-panel";
        panel.dataset.pageId = page.id;

        if (page.title) {
          const h = document.createElement("h1");
          h.className = "ui-docs-panel-title";
          h.textContent = page.title;
          panel.appendChild(h);
        }

        panels[page.id] = panel;
        content.appendChild(panel);
      });
    });

    // 最初のページをアクティブにする
    if (firstPageId) {
      const firstPageEl = sidebar.querySelector(`.ui-docs-page[data-page-id="${firstPageId}"]`);
      if (firstPageEl) firstPageEl.classList.add("is-active");
      if (panels[firstPageId]) panels[firstPageId].classList.add("is-active");
    }

    // componentsを、それぞれの page プロパティが指すパネルに振り分ける
    components.forEach((c) => {
      const el = createComponent(c);
      if (!el) return;

      const targetPanel = c.page && panels[c.page] ? panels[c.page] : panels[firstPageId];
      if (targetPanel) targetPanel.appendChild(el);
    });

    root.appendChild(sidebar);
    root.appendChild(content);
  }


  /* ============================================================
   * 5. エラー表示（.sorauiの読み込み・JSON解析に失敗した場合）
   * ============================================================ */
  function renderError(root, message) {
    const pre = document.createElement("div");
    pre.className = "ui-error";
    pre.textContent = `[Sora UI] ${message}`;
    root.appendChild(pre);
  }

  /* ============================================================
   * 6. 描画の共通処理
   *    data（JSオブジェクト）を受け取って、rootに描画する。
   *    .sorauiファイルから読んだ場合も、Firestoreなど外部データから
   *    その場で組み立てた場合も、最終的にここを通る。
   * ============================================================ */
  function renderData(root, data) {
    root.innerHTML = "";
    root.classList.remove("ui-docs");

    injectStyles(data.theme);
    root.classList.add("ui-root");

    if (data.mode === "Docs") {
      renderDocs(root, data);
    } else {
      renderTabs(root, data);
    }
  }

  /* ============================================================
   * 7. 起動処理（ファイル読み込みルート）
   *    data-soraui-src を持つ要素をすべて見つけて、
   *    指定された .soraui (JSON) を fetch して描画する
   * ============================================================ */
  async function mountElement(root) {
    const src = root.dataset.sorauiSrc;
    if (!src) return;

    try {
      const res = await fetch(src);
      if (!res.ok) {
        throw new Error(`"${src}" の読み込みに失敗しました (status: ${res.status})`);
      }

      const data = await res.json();
      renderData(root, data);
    } catch (err) {
      injectStyles(DEFAULT_THEME);
      root.classList.add("ui-root");
      renderError(root, err.message);
      console.error("[Sora UI]", err);
    }
  }

  /* ============================================================
   * 8. 外部APIルート（JSオブジェクトを直接渡して描画したい場合）
   *    例:
   *      const data = await fetch("/api/page-data").then(r => r.json());
   *      SoraUI.render("#app", data);
   *
   *    data の形式は .soraui ファイルの中身（JSON）と全く同じ。
   *    ファイルを経由せず、その場で組み立てたオブジェクトをそのまま渡せる。
   * ============================================================ */
  function render(target, data) {
    const root = typeof target === "string" ? document.querySelector(target) : target;
    if (!root) {
      console.error(`[Sora UI] render() の対象要素が見つかりません: "${target}"`);
      return;
    }

    try {
      renderData(root, data);
    } catch (err) {
      injectStyles(DEFAULT_THEME);
      root.classList.add("ui-root");
      renderError(root, err.message);
      console.error("[Sora UI]", err);
    }
  }

  function init() {
    const targets = document.querySelectorAll("[data-soraui-src]");
    targets.forEach(mountElement);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

  // 外部から使えるAPI
  //   SoraUI.reload()             -> data-soraui-src を持つ要素を再読み込み
  //   SoraUI.render(target, data) -> JSオブジェクトを直接渡して描画
  window.SoraUI = { reload: init, render: render };
})();