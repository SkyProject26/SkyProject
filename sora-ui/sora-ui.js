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
    `;

    const styleTag = document.createElement("style");
    styleTag.setAttribute("data-sora-ui", "true");
    styleTag.textContent = css;
    document.head.appendChild(styleTag);
  }

  /* ============================================================
   * 3. コンポーネント生成（JSON -> DOM）
   * ============================================================ */

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
   * 5. エラー表示（.sorauiの読み込み・JSON解析に失敗した場合）
   * ============================================================ */
  function renderError(root, message) {
    const pre = document.createElement("div");
    pre.className = "ui-error";
    pre.textContent = `[Sora UI] ${message}`;
    root.appendChild(pre);
  }

  /* ============================================================
   * 6. 起動処理
   *    data-soraui-src を持つ要素をすべて見つけて読み込む
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

      injectStyles(data.theme);
      root.classList.add("ui-root");

      renderTabs(root, data);
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

  // 必要であれば外部から再実行できるように公開しておく
  window.SoraUI = { reload: init };
})();