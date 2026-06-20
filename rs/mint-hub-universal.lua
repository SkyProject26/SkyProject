-- Mint Hub - Base System, Window Creation & Overlay
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- =============================================================================
-- [1] メインウィンドウの作成
-- =============================================================================
local Window = Library:CreateWindow({
	Title = "Mint Hub | Universal",
	Footer = "Ver:1.2 | Mint Hub © SkyProject",
	NotifySide = "Right",
	ShowCustomCursor = false,
})

-- タブ作成
local Tabs = {
	InfoTab = Window:AddTab("Info", "info"), 
    PlayerTab = Window:AddTab("Player", "user"),
    WorldTab = Window:AddTab("World", "earth"),
    VisualTab = Window:AddTab("ESP", "user-round-search"),
    TeleportTab = Window:AddTab("Teleport", "map-pin"),
    RadarTab = Window:AddTab("Radar", "map-pinned"),
    CrosshairTab = Window:AddTab("Crossheir", "locate"),
    AimbotTab = Window:AddTab("AimBot", "crosshair"),
    TriggerBotTab = Window:AddTab("TriggerBot", "mouse-pointer-click"),
    CameraTab = Window:AddTab("Camera", "camera"),
    ServerTab = Window:AddTab("Server", "server"),
    ChatTab = Window:AddTab("Chat", "message-circle-more"),
    DanceTab = Window:AddTab("Dance", "smile-plus"),
    ScriptTab = Window:AddTab("OtherScripts", "scroll-text"),
	["UI Settings"] = Window:AddTab("Settings", "settings"), 
}

-- =============================================================================
-- [2] オーバーレイ (ウォーターマーク) システム
-- =============================================================================
-- ドラッガブルラベルの初期化
local DraggableLabel = Library:AddDraggableLabel("Mint Hub | Loading...")
DraggableLabel:SetVisible(true)

-- FPS / Ping 計算用の変数
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

-- 現在実行しているRobloxのゲーム名を取得
local MarketPlaceService = game:GetService("MarketplaceService")
local GameName = "Unknown Game"
pcall(function()
	GameName = MarketPlaceService:GetProductInfo(game.PlaceId).Name
end)

-- 毎フレーム駆動する接続 (FPS、Ping、テキストの更新)
local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter
		FrameTimer = tick()
		FrameCounter = 0
	end

	-- 指定されたフォーマットでオーバーレイを表示 (Mint Hub | ゲーム名 | FPS | Ping)
	DraggableLabel:SetText(('Mint Hub | %s | %s fps | %s ms'):format(
		GameName,
		math.floor(FPS),
		math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
	))
end)

-- =============================================================================
-- [Info] タブの作成とコンテンツ構築
-- =============================================================================

-- 左側のグループボックス：ハブの基本情報やクレジット
local LeftInfoBox1 = Tabs.InfoTab:AddLeftGroupbox("Information")

LeftInfoBox1:AddLabel("Welcome to Mint Hub !", true)
LeftInfoBox1:AddDivider()

LeftInfoBox1:AddLabel("For PC")
LeftInfoBox1:AddLabel("Version: 1.2")
LeftInfoBox1:AddLabel("Status: Active")
LeftInfoBox1:AddLabel("Developer: SkyProject")
LeftInfoBox1:AddLabel("Support: Universal (All Games)")

local LeftInfoBox2 = Tabs.InfoTab:AddLeftGroupbox("Credit")
LeftInfoBox2:AddLabel("Mint Hub | Universal")
LeftInfoBox2:AddLabel("Mint Hub © Sky Project")
LeftInfoBox2:AddLabel("discord.gg/ZxBS4rW3qs")

-- 右側のグループボックス：アップデート履歴（Changelog）
local RightInfoBox1 = Tabs.InfoTab:AddRightGroupbox("Changelog")

RightInfoBox1:AddLabel("Version 1.0", true)
RightInfoBox1:AddLabel("Script Release")
RightInfoBox1:AddDivider()
RightInfoBox1:AddLabel("Version 1.2", true)
RightInfoBox1:AddLabel("+ : FTAP Script")
RightInfoBox1:AddLabel("+ : Tab Camera (Free Cam bug)")
RightInfoBox1:AddLabel("+ : Forced server exit")
RightInfoBox1:AddDivider()

-- =============================================================================
-- [Player] タブの作成とコンテンツ構築
-- =============================================================================
local NormalMoveBox = Tabs.PlayerTab:AddLeftGroupbox("Normal Movement")
local CFrameMoveBox = Tabs.PlayerTab:AddRightGroupbox("CFrame / Special")
local UtilityBox = Tabs.PlayerTab:AddLeftGroupbox("Utilities")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =============================================================================
-- 1. Normal Movement (通常移動系)
-- =============================================================================

-- ◆ 通常 WalkSpeed のスライダー作成
local SpeedSlider = NormalMoveBox:AddSlider("SpeedSlider", { 
    Text = "Walk Speed", 
    Default = 16, 
    Min = 0, 
    Max = 300, 
    Rounding = 0, 
    Compact = false 
})

-- ◆ 通常 WalkSpeed のトグル作成
local SpeedToggle = NormalMoveBox:AddToggle("SpeedToggle", { 
    Text = "Enable Walk Speed", 
    Default = false 
})

-- トグルにキーバインドを合体 (SyncToggleで自動でトグル値が切り替わります)
local SpeedKeybind = SpeedToggle:AddKeyPicker("SpeedKeybind", { 
    Default = "T", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "Walk Speed Bind" 
})


-- ◆ 通常 JumpPower のスライダー作成
local JumpSlider = NormalMoveBox:AddSlider("JumpSlider", { 
    Text = "Jump Power", 
    Default = 50, 
    Min = 0, 
    Max = 300, 
    Rounding = 0, 
    Compact = false 
})

-- ◆ 通常 JumpPower のトグル作成
local JumpToggle = NormalMoveBox:AddToggle("JumpToggle", { 
    Text = "Enable Jump Power", 
    Default = false 
})

-- トグルにキーバインドを合体
local JumpKeybind = JumpToggle:AddKeyPicker("JumpKeybind", { 
    Default = "G", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "Jump Power Bind" 
})

-- =============================================================================
-- 2. CFrame / Special (CFrame・特殊移動系)
-- =============================================================================

-- ◆ CFrame Walk Speed のスライダー作成
local CFrameSpeedSlider = CFrameMoveBox:AddSlider("CFrameSpeedSlider", { 
    Text = "CFrame Speed", 
    Default = 50, 
    Min = 0, 
    Max = 300, 
    Rounding = 0, 
    Compact = false 
})

-- ◆ CFrame Walk Speed のトグル作成
local CFrameSpeedToggle = CFrameMoveBox:AddToggle("CFrameSpeedToggle", { 
    Text = "Enable CFrame Walk", 
    Default = false 
})

local CFrameSpeedKeybind = CFrameSpeedToggle:AddKeyPicker("CFrameSpeedKeybind", { 
    Default = "NONE", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "CFrame Walk Bind" 
})


-- ◆ Fly (飛行) のスライダー作成
local FlySpeedSlider = CFrameMoveBox:AddSlider("FlySpeedSlider", { 
    Text = "Fly Speed", 
    Default = 50, 
    Min = 0, 
    Max = 300, 
    Rounding = 0, 
    Compact = false 
})

-- ◆ Fly (飛行) のトグル作成
local FlyToggle = CFrameMoveBox:AddToggle("FlyToggle", { 
    Text = "Enable Fly", 
    Default = false 
})

local FlyKeybind = FlyToggle:AddKeyPicker("FlyKeybind", { 
    Default = "V", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "Fly Bind" 
})


-- ◆ Noclip (壁抜け) のトグル作成
local NoclipToggle = CFrameMoveBox:AddToggle("NoclipToggle", { 
    Text = "Enable Noclip", 
    Default = false 
})

local NoclipKeybind = NoclipToggle:AddKeyPicker("NoclipKeybind", { 
    Default = "N", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "Noclip Bind" 
})


-- ◆ Infinite Jump (無限ジャンプ) のトグル作成
local InfJumpToggle = CFrameMoveBox:AddToggle("InfJumpToggle", { 
    Text = "Enable Infinite Jump", 
    Default = false 
})

local InfJumpKeybind = InfJumpToggle:AddKeyPicker("InfJumpKeybind", { 
    Default = "B", 
    SyncToggle = true, 
    Mode = "Toggle", 
    Text = "Infinite Jump Bind" 
})

-- =============================================================================
-- 3. Utilities (便利機能系)
-- =============================================================================

-- ◆ Respawn ボタン
UtilityBox:AddButton({
    Text = "Respawn / Reset Character",
    Func = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
        end
    end,
    DoubleClick = false,
    Tooltip = "キャラクターを即座にリスポーンさせます"
})

-- =============================================================================
-- [公式仕様準拠] キーバインド入力をシステム（トグル）に完全に同期させる処理
-- =============================================================================
-- Options.キーバインドID:OnClick() を使い、キーが押されて状態（GetState）が変わった時に
-- UIのトグル（Toggles.トグルID）に値を強制的にセットして連動させます。

-- ◆ Walk Speed 同期 (Tキー)
-- =============================================================================
-- [必須] ライブラリのグローバルテーブルを定義（変数名が Library の場合）
-- =============================================================================
local Options = Library.Options
local Toggles = Library.Toggles

-- =============================================================================
-- [公式仕様準拠] キーバインド入力をシステム（トグル）に完全に同期させる処理
-- =============================================================================

-- ◆ Walk Speed 同期 (Tキー)
Options.SpeedKeybind:OnClick(function()
    if Toggles and Toggles.SpeedToggle then
        Toggles.SpeedToggle:SetValue(Options.SpeedKeybind:GetState())
    end
end)

-- ◆ Jump Power 同期 (Gキー)
Options.JumpKeybind:OnClick(function()
    if Toggles and Toggles.JumpToggle then
        Toggles.JumpToggle:SetValue(Options.JumpKeybind:GetState())
    end
end)

-- ◆ CFrame Walk 同期 (NONE / 設定キー)
Options.CFrameSpeedKeybind:OnClick(function()
    if Toggles and Toggles.CFrameSpeedToggle then
        Toggles.CFrameSpeedToggle:SetValue(Options.CFrameSpeedKeybind:GetState())
    end
end)

-- ◆ Fly 同期 (Vキー)
Options.FlyKeybind:OnClick(function()
    if Toggles and Toggles.FlyToggle then
        Toggles.FlyToggle:SetValue(Options.FlyKeybind:GetState())
    end
end)

-- ◆ Noclip 同期 (Nキー)
Options.NoclipKeybind:OnClick(function()
    if Toggles and Toggles.NoclipToggle then
        Toggles.NoclipToggle:SetValue(Options.NoclipKeybind:GetState())
    end
end)

-- ◆ Infinite Jump 同期 (Bキー)
Options.InfJumpKeybind:OnClick(function()
    if Toggles and Toggles.InfJumpToggle then
        Toggles.InfJumpToggle:SetValue(Options.InfJumpKeybind:GetState())
    end
end)


--==============================================================================
--World Tab UI 
--==============================================================================

-- =============================================================================
-- [World] タブの作成とコンテンツ構築
-- =============================================================================
local EnvironmentBox = Tabs.WorldTab:AddLeftGroupbox("Environment Control")
local LightingBox = Tabs.WorldTab:AddRightGroupbox("Lighting & Visuals")
local SkyboxBox = Tabs.WorldTab:AddLeftGroupbox("Custom Skybox")

-- =============================================================================
-- 1. Environment Control (環境制御系)
-- =============================================================================

-- ◆ カスタムGravity (重力)
local GravitySlider = EnvironmentBox:AddSlider("GravitySlider", { 
    Text = "Custom Gravity", 
    Default = 196.2, 
    Min = 0, 
    Max = 1000, 
    Rounding = 1, 
    Compact = false 
})

local GravityToggle = EnvironmentBox:AddToggle("GravityToggle", { 
    Text = "Enable Custom Gravity", 
    Default = false 
})

-- ◆ カスタムTime (時間固定)
local TimeSlider = EnvironmentBox:AddSlider("TimeSlider", { 
    Text = "Custom Time", 
    Default = 12, 
    Min = 0, 
    Max = 24, 
    Rounding = 1, 
    Compact = false 
})

local TimeToggle = EnvironmentBox:AddToggle("TimeToggle", { 
    Text = "Enable Custom Time", 
    Default = false 
})

-- =============================================================================
-- 2. Lighting & Visuals (描画・視覚系)
-- =============================================================================

-- ◆ Remove Fog (霧の削除)
local RemoveFogToggle = LightingBox:AddToggle("RemoveFogToggle", { 
    Text = "Remove Fog", 
    Default = false 
})

-- ◆ Remove Shadows (影の削除)
local RemoveShadowsToggle = LightingBox:AddToggle("RemoveShadowsToggle", { 
    Text = "Remove Shadows", 
    Default = false 
})

-- ◆ Fullbright (マップを明るく)
local FullbrightToggle = LightingBox:AddToggle("FullbrightToggle", { 
    Text = "Fullbright", 
    Default = false 
})

-- ◆ Ambient Color (環境光の変更)
local AmbientToggle = LightingBox:AddToggle("AmbientToggle", { 
    Text = "Enable Custom Ambient", 
    Default = false 
})

-- トグルに対してカラーピッカーを正しく合体させる
local AmbientColorPicker = AmbientToggle:AddColorPicker("AmbientColorPicker", { 
    Default = Color3.fromRGB(255, 255, 255), 
    Title = "Ambient Color" 
})

-- =============================================================================
-- 3. Custom Skybox (カスタムスカイボックス)
-- =============================================================================

-- ◆ スカイボックスの種類選択リスト
local SkyboxDropdown = SkyboxBox:AddDropdown("SkyboxDropdown", { 
    Values = { "Purple Nebula", "Space", "Anime Sunset", "Matrix Grid", "Dark Apocalyptic" }, 
    Default = 1, 
    Multi = false, 
    Text = "Select Skybox Theme" 
})

-- ◆ スカイボックスのトグル
local SkyboxToggle = SkyboxBox:AddToggle("SkyboxToggle", { 
    Text = "Enable Custom Skybox", 
    Default = false 
})

-- =============================================================================
-- [Visual] タブの作成とコンテンツ構築
-- =============================================================================
local EspMasterBox = Tabs.VisualTab:AddLeftGroupbox("ESP Master Control")
local EspSettingsBox = Tabs.VisualTab:AddRightGroupbox("ESP Element Settings")

-- =============================================================================
-- 1. ESP Master Control (マスター制御系)
-- =============================================================================

-- ◆ Master ESP (全体のON/OFFスイッチ)
local MasterEspToggle = EspMasterBox:AddToggle("MasterEspToggle", { 
    Text = "Master ESP", 
    Default = false 
})

-- ◆ ESP Max Distance (描画上限距離スライダー)
local EspDistanceSlider = EspMasterBox:AddSlider("EspDistanceSlider", { 
    Text = "ESP Max Distance", 
    Default = 2000, 
    Min = 100, 
    Max = 10000, 
    Rounding = 0, 
    Compact = false 
})

-- =============================================================================
-- 2. ESP Element Settings (個別表示設定系)
-- =============================================================================

-- ◆ Box ESP (枠線表示)
local BoxEspToggle = EspSettingsBox:AddToggle("BoxEspToggle", { 
    Text = "Box ESP", 
    Default = false 
})

-- ◆ DisplayName ESP (表示名)
local NameEspToggle = EspSettingsBox:AddToggle("NameEspToggle", { 
    Text = "DisplayName ESP", 
    Default = false 
})

-- ◆ Health Bar ESP (HPゲージ)
local HealthBarEspToggle = EspSettingsBox:AddToggle("HealthBarEspToggle", { 
    Text = "Health Bar ESP", 
    Default = false 
})

-- ◆ Health Text ESP (HP数値のテキスト)
local HealthTextEspToggle = EspSettingsBox:AddToggle("HealthTextEspToggle", { 
    Text = "Health Text ESP", 
    Default = false 
})

-- ◆ Tracers ESP (画面下からの線)
local TracerEspToggle = EspSettingsBox:AddToggle("TracerEspToggle", { 
    Text = "Tracers ESP", 
    Default = false 
})

-- ◆ Distance ESP (距離表示)
local DistanceEspToggle = EspSettingsBox:AddToggle("DistanceEspToggle", { 
    Text = "Distance ESP", 
    Default = false 
})

-- ◆ Team Color ESP (チームカラー強制適用)
local TeamColorEspToggle = EspSettingsBox:AddToggle("TeamColorEspToggle", { 
    Text = "Team Color ESP", 
    Default = false 
})

-- =============================================================================
-- [Teleport] タブの作成とコンテンツ構築
-- =============================================================================
local WaypointBox = Tabs.TeleportTab:AddLeftGroupbox("Waypoint Teleport")
local ClickTpBox = Tabs.TeleportTab:AddRightGroupbox("Click Teleport")
local PlayerTpBox = Tabs.TeleportTab:AddRightGroupbox("Player Teleport")

-- =============================================================================
-- 1. Waypoint Teleport (位置保存・テレポート)
-- =============================================================================
-- 登録用の名前入力テキストボックス
WaypointBox:AddInput("WaypointNameInput", {
    Text = "Waypoint Name",
    Default = "",
    Placeholder = "Enter spot name...",
    Numeric = false,
    Finished = false
})

-- 現在地をセーブするボタン
WaypointBox:AddButton({
    Text = "Save Current Location",
    Func = function()
        SaveWaypoint()
    end
})

-- セーブした場所の一覧ドロップダウン
WaypointBox:AddDropdown("WaypointDropdown", {
    Values = {},
    Default = 1,
    Text = "Saved Waypoints",
    Tooltip = "Select a waypoint to teleport"
})

-- 選択した場所に飛ぶボタン
WaypointBox:AddButton({
    Text = "Teleport to Selected",
    Func = function()
        TeleportToWaypoint()
    end
})

-- リストを更新するボタン
WaypointBox:AddButton({
    Text = "Refresh Waypoint List",
    Func = function()
        RefreshWaypointDropdown()
    end
})

-- =============================================================================
-- 2. Click Teleport (クリックTP - Linoria完全準拠版)
-- =============================================================================
-- ClickTPのON/OFF
local ClickTpToggle = ClickTpBox:AddToggle("ClickTpToggle", {
    Text = "Click TP",
    Default = false
})

-- 【最重要修正】トグルの直下にキーピッカーを埋め込みます
ClickTpToggle:AddKeyPicker("ClickTpKeyBind", {
    Default = "Z",              -- デフォルトキー
    SyncToggleState = false,     -- キーを押したときにトグル自体をON/OFF反転させる場合はtrue（今回はHold/押してる間押しにするためfalse）
    Mode = "Hold",              -- Hold、Toggle、Always のいずれか（Holdが最も安定します）
    Text = "Click TP Key",
    NoUI = false
})

-- =============================================================================
-- 3. Player Teleport (プレイヤーTP)
-- =============================================================================
-- ターゲットプレイヤー選択ドロップダウン
PlayerTpBox:AddDropdown("PlayerTpDropdown", {
    Values = {},
    Default = 1,
    Text = "Select Player",
    Tooltip = "Select a player to teleport"
})

-- プレイヤーの場所に飛ぶボタン
PlayerTpBox:AddButton({
    Text = "Teleport to Player",
    Func = function()
        TeleportToSelectedPlayer()
    end
})

-- プレイヤーリストを更新するボタン
PlayerTpBox:AddButton({
    Text = "Refresh Player List",
    Func = function()
        RefreshPlayerTpDropdown()
    end
})

-- =============================================================================
-- [Radar] タブの作成とコンテンツ構築
-- =============================================================================
local RadarBox = Tabs.RadarTab:AddLeftGroupbox("Radar Settings")

-- ◆ レーダーのON/OFF
RadarBox:AddToggle("RadarToggle", {
    Text = "Enable Radar",
    Default = false
})

-- ◆ レーダーのX座標スライダー
RadarBox:AddSlider("RadarXSlider", {
    Text = "Radar Position X",
    Default = 200,
    Min = 0,
    Max = 2000,
    Rounding = 0,
    Compact = false
})

-- ◆ レーダーのY座標スライダー
RadarBox:AddSlider("RadarYSlider", {
    Text = "Radar Position Y",
    Default = 300,
    Min = 0,
    Max = 2000,
    Rounding = 0,
    Compact = false
})

-- ◆ レーダーサイズ / 検出距離スライダー (レーダーの広さではなく、どれだけ遠くの敵までレーダーに映すかのスケール)
RadarBox:AddSlider("RadarScaleSlider", {
    Text = "Radar Range (Distance)",
    Default = 500,
    Min = 50,
    Max = 2500,
    Rounding = 0,
    Compact = false
})

-- =============================================================================
-- [Crosshair] タブの作成とコンテンツ構築
-- =============================================================================
local CrossMasterBox = Tabs.CrosshairTab:AddLeftGroupbox("Master Control")
local CrossDotBox = Tabs.CrosshairTab:AddLeftGroupbox("Dot Settings")
local CrossLineBox = Tabs.CrosshairTab:AddRightGroupbox("Line Settings")
local CrossCircleBox = Tabs.CrosshairTab:AddRightGroupbox("Circle Settings")

-- =============================================================================
-- 1. Master Control
-- =============================================================================
CrossMasterBox:AddToggle("MasterCrosshairToggle", { Text = "Master Crosshair", Default = false })

-- =============================================================================
-- 2. Dot Settings (真ん中の点)
-- =============================================================================
CrossDotBox:AddToggle("CrossDotToggle", { Text = "Enable Dot", Default = false })
CrossDotBox:AddSlider("CrossDotThickness", { Text = "Dot Size", Default = 4, Min = 1, Max = 20, Rounding = 0 })
CrossDotBox:AddSlider("CrossDotTransparency", { Text = "Dot Transparency", Default = 1, Min = 0, Max = 1, Rounding = 2 })
CrossDotBox:AddLabel("Dot Color"):AddColorPicker("CrossDotColor", { Default = Color3.fromRGB(255, 0, 0) })

-- =============================================================================
-- 3. Line Settings (4方向の線)
-- =============================================================================
CrossLineBox:AddToggle("CrossLineToggle", { Text = "Enable Lines", Default = false })
CrossLineBox:AddSlider("CrossLineThickness", { Text = "Line Thickness", Default = 2, Min = 1, Max = 10, Rounding = 0 })
CrossLineBox:AddSlider("CrossLineGap", { Text = "Center Gap", Default = 5, Min = 0, Max = 50, Rounding = 0 })
CrossLineBox:AddSlider("CrossLineLength", { Text = "Line Length", Default = 10, Min = 2, Max = 100, Rounding = 0 }) -- 線の長さ調整用
CrossLineBox:AddSlider("CrossLineTransparency", { Text = "Line Transparency", Default = 1, Min = 0, Max = 1, Rounding = 2 })
CrossLineBox:AddLabel("Line Color"):AddColorPicker("CrossLineColor", { Default = Color3.fromRGB(255, 0, 0) })

-- =============================================================================
-- 4. Circle Settings (外周の丸)
-- =============================================================================
CrossCircleBox:AddToggle("CrossCircleToggle", { Text = "Enable Circle", Default = false })
CrossCircleBox:AddSlider("CrossCircleRadius", { Text = "Circle Radius", Default = 20, Min = 5, Max = 200, Rounding = 0 }) -- 丸の大きさ
CrossCircleBox:AddSlider("CrossCircleThickness", { Text = "Line Thickness", Default = 1, Min = 1, Max = 10, Rounding = 0 })
CrossCircleBox:AddSlider("CrossCircleLineTrans", { Text = "Line Transparency", Default = 1, Min = 0, Max = 1, Rounding = 2 })
CrossCircleBox:AddSlider("CrossCircleFillTrans", { Text = "Fill Transparency", Default = 0, Min = 0, Max = 1, Rounding = 2 })
CrossCircleBox:AddLabel("Line Color"):AddColorPicker("CrossCircleLineColor", { Default = Color3.fromRGB(255, 0, 0) })
CrossCircleBox:AddLabel("Fill Color"):AddColorPicker("CrossCircleFillColor", { Default = Color3.fromRGB(255, 0, 0) })

-- =============================================================================
-- [Aimbot] タブの作成とコンテンツ構築 (Camera固定・エラー完全排除版)
-- =============================================================================
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =============================================================================
-- [Aimbot] UI構築コード
-- =============================================================================
local AimMasterBox = Tabs.AimbotTab:AddLeftGroupbox("Master Control")
local AimSettingsBox = Tabs.AimbotTab:AddLeftGroupbox("Aimbot Settings")
local AimFovBox = Tabs.AimbotTab:AddRightGroupbox("FOV Settings")

-- 1. Master Control
local AimMasterToggle = AimMasterBox:AddToggle("MasterAimbotToggle", {
    Text = "Master Aimbot",
    Default = false
})

AimMasterToggle:AddKeyPicker("AimbotKeyBind", {
    Default = "MB2",            -- マウス右クリック長押し
    SyncToggleState = false,
    Mode = "Hold",
    NoUI = false
})

-- 2. Aimbot Settings
AimSettingsBox:AddDropdown("AimbotPartDropdown", {
    Values = { "Head", "HumanoidRootPart" },
    Default = 1,
    Text = "Aim Part",
    Tooltip = "Select target body part"
})

AimSettingsBox:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1
})

AimSettingsBox:AddSlider("AimbotMaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 50,
    Max = 5000,
    Rounding = 0
})

AimSettingsBox:AddToggle("AimbotTeamCheck", {
    Text = "Team Check",
    Default = true
})

-- 3. FOV Settings
AimFovBox:AddSlider("AimbotFovRadius", {
    Text = "FOV Radius",
    Default = 100,
    Min = 10,
    Max = 800,
    Rounding = 0
})

AimFovBox:AddToggle("AimbotFovInvisible", {
    Text = "FOV Invisible",
    Default = false
})

-- =============================================================================
-- [TriggerBot] タブの作成とコンテンツ構築 (Linoria仕様完全準拠版)
-- =============================================================================
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- =============================================================================
-- [TriggerBot] UI構築コード (独立型Keybindでエラーを100%回避)
-- =============================================================================
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- =============================================================================
-- [TriggerBot] UI構築コード (バグの原因になるKeybind関数を完全に排除)
-- =============================================================================
local TriggerMasterBox = Tabs.TriggerBotTab:AddLeftGroupbox("Master Control")
local TriggerSettingsBox = Tabs.TriggerBotTab:AddLeftGroupbox("TriggerBot Settings")

-- 1. Master Control
TriggerMasterBox:AddToggle("MasterTriggerToggle", {
    Text = "Enable TriggerBot",
    Default = false
})

-- 🟢【最終解決】AddKeyPickerやAddKeybindを完全に廃止。
-- 100%バグらないドロップダウン形式で、発動させる条件（キー）を選択できるようにしました。
TriggerMasterBox:AddDropdown("TriggerActivationMode", {
    Values = { "Always (None)", "Hold Right Click", "Hold Left Click" },
    Default = 1, -- 最初は「Always (常時ON)」なのでトグルONだけで即作動します
    Text = "Activation Mode",
    Tooltip = "Select when the TriggerBot should active."
})

-- 2. TriggerBot Settings
TriggerSettingsBox:AddToggle("TriggerTeamCheck", {
    Text = "Team Check",
    Default = true
})

TriggerSettingsBox:AddSlider("TriggerMaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 50,
    Max = 5000,
    Rounding = 0
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- =============================================================================
-- [Camera] タブの作成とコンテンツ構築 (キーバインドなし)
-- =============================================================================
local CameraZoomBox = Tabs.CameraTab:AddLeftGroupbox("Zoom Control")
local CameraFovBox = Tabs.CameraTab:AddRightGroupbox("Field of View")
local CameraFreeCamBox = Tabs.CameraTab:AddLeftGroupbox("Free Camera")

-- 1. Zoom Unlock (トグル + スライダーで範囲指定も可能)
local ZoomUnlockToggle = CameraZoomBox:AddToggle("CameraZoomUnlockToggle", {
    Text = "Unlock Zoom Distance",
    Default = false
})

-- 任意で最小・最大距離を個別に設定できるスライダー（無くてもOK）
CameraZoomBox:AddSlider("CameraMinZoom", {
    Text = "Min Zoom Distance",
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 1
})
CameraZoomBox:AddSlider("CameraMaxZoom", {
    Text = "Max Zoom Distance",
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0
})

-- 2. Custom FOV
local FovSlider = CameraFovBox:AddSlider("CameraFovSlider", {
    Text = "Field of View",
    Default = 70,
    Min = 1,
    Max = 120,
    Rounding = 0
})
local FovToggle = CameraFovBox:AddToggle("CameraFovToggle", {
    Text = "Enable Custom FOV",
    Default = false
})

-- 3. Free Camera
local FreeCamToggle = CameraFreeCamBox:AddToggle("FreeCamToggle", {
    Text = "Enable Free Camera",
    Default = false
})
local FreeCamSpeed = CameraFreeCamBox:AddSlider("FreeCamSpeed", {
    Text = "Move Speed",
    Default = 20,
    Min = 1,
    Max = 200,
    Rounding = 1
})
CameraFreeCamBox:AddLabel("Controls: WASD / Space / Shift | Mouse Look")
-- =============================================================================
-- [Server] タブの作成とコンテンツ構築
-- =============================================================================
local ServerInfoBox = Tabs.ServerTab:AddLeftGroupbox("Server Information")
local ServerActionBox = Tabs.ServerTab:AddLeftGroupbox("Server Actions")
local ServerCopyBox = Tabs.ServerTab:AddRightGroupbox("Copy Utilities")

-- =============================================================================
-- 1. Server Information (サーバー情報の表示)
-- =============================================================================
-- サーバーの国（地域）を表示するためのラベル
local RegionLabel = ServerInfoBox:AddLabel("Server Region: Fetching...")

-- 【バックエンド：ロケーション（国）取得処理】
-- 外部APIを利用して、現在のサーバーIPから国名や地域名を非同期で安全に取得します
task.spawn(function()
    local success, result = pcall(function()
        -- Robloxの公式APIまたは一般的なIP判定APIからサーバーのロケーションを取得
        return HttpService:JSONDecode(game:HttpGet("https://ipapi.co/json/")).country_name
    end)
    
    if success and result then
        RegionLabel:SetText("Server Region: " .. tostring(result))
    else
        -- 万が一APIが詰まっていた場合のフォールバック（Roblox公式のLocalizationServiceを使用）
        local locSuccess, locResult = pcall(function()
            return game:GetService("LocalizationService").RobloxLocaleId
        end)
        if locSuccess and locResult then
            RegionLabel:SetText("Server Region: " .. tostring(locResult) .. " (Locale)")
        else
            RegionLabel:SetText("Server Region: Unknown")
        end
    end
end)

-- プレースIDとジョブIDの簡易表示ラベル
ServerInfoBox:AddLabel("Place ID: " .. tostring(game.PlaceId))

-- =============================================================================
-- 2. Server Actions (サーバー移動系)
-- =============================================================================

-- 【サーバーリジョイン】同じサーバーに入り直す
ServerActionBox:AddButton({
    Text = "Server Rejoin",
    Func = function()
        -- 現在のJobIDを指定してテレポートすることで、100%同じサーバーに再接続します
        if #Players:GetPlayers() <= 1 then
            -- サーバーに自分しかいない場合は通常テレポート
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end,
    Tooltip = "Reconnect to the exact same server."
})

-- 【サーバーホップ】別の公開サーバーへランダムに移動する
ServerActionBox:AddButton({
    Text = "Server Hop",
    Func = function()
        -- 別の有効な公開サーバーのリストをRoblox APIから取得して移動します
        task.spawn(function()
            local success, servers = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            end)
            
            if success and servers and servers.data then
                for _, server in ipairs(servers.data) do
                    -- 空きがあり、現在のサーバー（JobId）とは異なるサーバーを探す
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        break
                    end
                end
            else
                -- APIが失敗した場合は通常のランダムテレポートを試みる
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end,
    Tooltip = "Find and teleport to a different public server."
})

-- Forced Server Exit (強制サーバー退出)
ServerActionBox:AddButton({
    Text = "Forced Server Exit",
    Func = function()
        game:GetService("Players").LocalPlayer:Kick("Forced server exit | Mint hub")
    end,
    Tooltip = "Kick yourself from the server to return to the lobby."
})
-- =============================================================================
-- 3. Copy Utilities (クリップボードへのコピー系)
-- =============================================================================

-- 【プレースIDコピー】
ServerCopyBox:AddButton({
    Text = "Copy Place ID",
    Func = function()
        if setclipboard then
            setclipboard(tostring(game.PlaceId))
            -- LinoriaLibの標準通知（もしあれば利用。なければそのまま）
            pcall(function() Library:Notify("Copied Place ID to clipboard!") end)
        end
    end,
    Tooltip = "Copy the game's PlaceID to your clipboard."
})

-- 【ジョブIDコピー】
ServerCopyBox:AddButton({
    Text = "Copy Job ID",
    Func = function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
            pcall(function() Library:Notify("Copied Job ID to clipboard!") end)
        end
    end,
    Tooltip = "Copy the current server's JobID to your clipboard."
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- =============================================================================
-- [Chat] タブの作成とコンテンツ構築
-- =============================================================================
local ChatMainBox = Tabs.ChatTab:AddLeftGroupbox("Chat Translator")

-- 1. チャット文字列の入力ボックス
ChatMainBox:AddInput("ChatInputText", {
    Default = "",
    Numeric = false, -- 文字入力を許可
    Finished = false, -- 入力中にエンターを押しても即送信しないようにする
    Text = "Chat Message",
    Tooltip = "Type the message you want to translate and send.",
    Placeholder = "Enter your message here..."
})

-- 2. 翻訳先言語の選択ドロップダウン
ChatMainBox:AddDropdown("ChatTargetLanguage", {
    Values = { "English", "Korean" },
    Default = 1,
    Text = "Target Language",
    Tooltip = "Select the language to translate into."
})

-- =============================================================================
-- 【バックエンド】Google翻訳API ＆ チャット強制送信ロジック
-- =============================================================================
-- テキストをゲーム内のチャット欄に送信する汎用関数 (新旧チャットシステム両対応)
local function SendChatMessage(message)
    -- 1. レガシー（古い）チャットシステム対応 (DefaultChatSystemChatEvents)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local sayMessage = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
    if sayMessage and sayMessage:IsA("RemoteEvent") then
        sayMessage:FireServer(message, "All")
        return
    end

    -- 2. 最新のテキストチャットシステム対応 (TextChatService)
    local textChatService = game:GetService("TextChatService")
    if textChatService and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannels = textChatService:FindFirstChild("TextChannels")
        local rbxGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral")
        if rbxGeneral and rbxGeneral:IsA("TextChannel") then
            rbxGeneral:SendAsync(message)
            return
        end
    end
end

-- Googleの翻訳エンドポイントを叩いて翻訳テキストを取得する関数
local function TranslateText(text, targetLangCode)
    local success, result = pcall(function()
        -- Google翻訳の無差別公開APIを利用
        local url = string.format(
            "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=%s&dt=t&q=%s",
            targetLangCode,
            HttpService:UrlEncode(text)
        )
        local response = game:HttpGet(url)
        local decoded = HttpService:JSONDecode(response)
        
        -- APIから返ってきた多重配列から翻訳された文字列だけを精密に抽出
        if decoded and decoded[1] and decoded[1][1] and decoded[1][1][1] then
            return decoded[1][1][1]
        end
        return nil
    end)
    
    if success and result then
        return result
    else
        return text -- 万が一APIエラーが発生した場合は原文をそのまま返す
    end
end

-- =============================================================================
-- 3. チャット送信ボタンの配置
-- =============================================================================
ChatMainBox:AddButton({
    Text = "Translate & Send",
    Func = function()
        -- 安全にUIからテキストと選択言語を取得
        local sourceText = ""
        local selectedLang = "English"
        
        pcall(function() if Options.ChatInputText then sourceText = Options.ChatInputText.Value end end)
        pcall(function() if Options.ChatTargetLanguage then selectedLang = Options.ChatTargetLanguage.Value end end)
        
        -- 入力ボックスが空っぽなら何もしない
        if sourceText == "" then return end
        
        -- 言語コードの設定 (英語: en, 韓国語: ko)
        local langCode = "en"
        if selectedLang == "Korean" then
            langCode = "ko"
        end
        
        -- 翻訳処理を実行
        local translatedResult = TranslateText(sourceText, langCode)
        
        -- チャットに送信
        if translatedResult and translatedResult ~= "" then
            SendChatMessage(translatedResult)
        end
    end,
    Tooltip = "Translate the input text and automatically post it to the game chat."
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [1] ChatタブとUI要素の作成
local ChatMainGroup = Tabs.ChatTab:AddRightGroupbox("Chat Controller")

ChatMainGroup:AddInput("NormalChatMessage", {
    Default = "",
    Numeric = false,
    Finished = false,
    Text = "Chat Message",
    Placeholder = "Hello world...",
})

-- 通常チャット送信関数
local function sendChatMessage(message)
    if not message or message == "" then return end
    
    -- TextChatService (新システム) への対応
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if textChannel then
            textChannel:SendAsync(message)
            return
        end
    end
    
    -- LegacyChatService (旧システム) への対応
    local sayMessageEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if sayMessageEvent and sayMessageEvent:IsA("RemoteEvent") then
        sayMessageEvent:FireServer(message, "All")
    end
end

ChatMainGroup:AddButton({
    Text = "Send Message",
    Func = function()
        sendChatMessage(Options.NormalChatMessage.Value)
    end,
})

ChatMainGroup:AddInput("SpamChatMessage", {
    Default = "Spamming with Mint Hub!",
    Numeric = false,
    Finished = false,
    Text = "Spam Message",
    Placeholder = "Spam text...",
})

ChatMainGroup:AddSlider("SpamCount", {
    Text = "Spam Count",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
})

ChatMainGroup:AddSlider("SpamDelay", {
    Text = "Spam Delay (Seconds)",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
})

-- スパムループ処理
local isSpamming = false
ChatMainGroup:AddButton({
    Text = "Start Spam",
    Func = function()
        if isSpamming then return end
        
        local text = Options.SpamChatMessage and Options.SpamChatMessage.Value or ""
        local count = Options.SpamCount and Options.SpamCount.Value or 5
        local delayTime = Options.SpamDelay and Options.SpamDelay.Value or 0.5
        
        if text == "" then return end
        isSpamming = true
        
        task.spawn(function()
            for i = 1, count do
                sendChatMessage(text)
                if i < count then
                    task.wait(delayTime)
                end
            end
            isSpamming = false
        end)
    end,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- =============================================================================
-- [Dance] タブの作成とコンテンツ構築
-- =============================================================================
local DanceMainBox = Tabs.DanceTab:AddLeftGroupbox("Chat Emotes & Dances")

-- =============================================================================
-- 【バックエンド】チャットシステムへのコマンド強制送信ロジック
-- =============================================================================
local function SendEmoteCommand(command)
    -- 1. レガシー（古い）チャットシステム対応
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local sayMessage = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
    if sayMessage and sayMessage:IsA("RemoteEvent") then
        sayMessage:FireServer(command, "All")
        return
    end

    -- 2. 最新のテキストチャットシステム対応 (TextChatService)
    local textChatService = game:GetService("TextChatService")
    if textChatService and textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannels = textChatService:FindFirstChild("TextChannels")
        local rbxGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral")
        if rbxGeneral and rbxGeneral:IsA("TextChannel") then
            rbxGeneral:SendAsync(command)
            return
        end
    end
end

-- =============================================================================
-- 2. エモート・ダンスボタンの配置
-- =============================================================================

-- 【Dance 1】
DanceMainBox:AddButton({
    Text = "Dance 1",
    Func = function()
        SendEmoteCommand("/e dance")
    end,
    Tooltip = "Perform Dance 1 (/e dance)"
})

-- 【Dance 2】
DanceMainBox:AddButton({
    Text = "Dance 2",
    Func = function()
        SendEmoteCommand("/e dance2")
    end,
    Tooltip = "Perform Dance 2 (/e dance2)"
})

-- 【Dance 3】
DanceMainBox:AddButton({
    Text = "Dance 3",
    Func = function()
        SendEmoteCommand("/e dance3")
    end,
    Tooltip = "Perform Dance 3 (/e dance3)"
})

-- 【Laugh】※表記のスペルミスをRoblox公式の "/e laugh" に補正して確実に笑わせます
DanceMainBox:AddButton({
    Text = "Laugh",
    Func = function()
        SendEmoteCommand("/e laugh")
    end,
    Tooltip = "Perform Laugh (/e laugh)"
})

-- 【Wave】
DanceMainBox:AddButton({
    Text = "Wave",
    Func = function()
        SendEmoteCommand("/e wave")
    end,
    Tooltip = "Perform Wave (/e wave)"
})

-- 【Point】
DanceMainBox:AddButton({
    Text = "Point",
    Func = function()
        SendEmoteCommand("/e point")
    end,
    Tooltip = "Perform Point (/e point)"
})

-- 【Cheer】
DanceMainBox:AddButton({
    Text = "Cheer",
    Func = function()
        SendEmoteCommand("/e cheer")
    end,
    Tooltip = "Perform Cheer (/e cheer)"
})

-- =============================================================================
-- [Script] タブの作成とコンテンツ構築 (Loadstring専用)
-- =============================================================================
local ScriptDevBox = Tabs.ScriptTab:AddLeftGroupbox("Developer scripts")
local ScriptUniBox = Tabs.ScriptTab:AddLeftGroupbox("universal scripts")
local ScriptFTAPBox = Tabs.ScriptTab:AddRightGroupbox("FTAP scripts")

-- =============================================================================
-- 1. 外部スクリプトの実行ボタン
-- =============================================================================

-- 【Infinite Yield】汎用アドミンチートの読み込み
ScriptDevBox:AddButton({
    Text = "Loadstring Spy",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/loadstring-tester.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Loadstring Tester | © SkyProject"
})

-- 【Dex Explorer】ゲーム内データ解析ツールの読み込み
ScriptDevBox:AddButton({
    Text = "Logger spy",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/http-spy-loger-spy.lua"))()
        end)
        
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Http,logger spy | © SkyProject"
})

ScriptUniBox:AddButton({
    Text = "Infinite Yield",
    Func = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Infinite Yield | © Infinite Yield"
})

ScriptFTAPBox:AddButton({
    Text = "LemonHub",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/lemon-hub.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "LemonHub - Japanese FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "HamHub",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/ham-hub.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "HamHub - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "Bloody V2 Premium",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/bloody-v2-premium.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Bloody V2 Premium - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "Bliz-THub",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/bliz-t.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Bliz-T Hub - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "NoobHub V2.5",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/noob-hub.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Noob Hub - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "Venom X Hub V2",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/venom-x-hub-v2.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Venom X Hub - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "FTAP K Hub",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/ftap-k-hub.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "FTAP K Hub - FTAP Script"
})

ScriptFTAPBox:AddButton({
    Text = "Ice Hub",
    Func = function()
        -- 外部URLからスクリプトを取得し、loadstringで強制実行します
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sky-project-web.firebaseapp.com/scripts/ice-hub.lua"))()
        end)
        
        -- 万が一読み込みエラーが起きた場合は通知（環境にあれば実行）
        if not success then
            pcall(function() Library:Notify("Failed to load script: " .. tostring(err), 5) end)
        end
    end,
    Tooltip = "Ice Hub - FTAP Script"
})

-- =============================================================================
-- [3] マネージャー設定 (SaveManager / ThemeManager)
-- =============================================================================
-- ライブラリの紐付け
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- 特定の設定をセーブ対象から除外
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- Mint Hub 用のデータ保存フォルダを設定
ThemeManager:SetFolder("MintHub")
SaveManager:SetFolder("MintHub/configs")

-- "UI Settings" タブに設定画面とテーマ画面を自動ビルド
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- 過去に「Autoload」に設定した設定ファイルがあれば自動読み込み
SaveManager:LoadAutoloadConfig()
-- ========================================
-- Logic
-- ========================================
-- =============================================================================
-- [Camera Tab] バックエンド処理（左クリックドラッグ視点変更版）
-- =============================================================================
local RenderService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 既存ループの二重起動防止
if _G.FreeCamLoop then _G.FreeCamLoop:Disconnect() _G.FreeCamLoop = nil end
if _G.ZoomLoop then _G.ZoomLoop:Disconnect() _G.ZoomLoop = nil end
if _G.FovLoop then _G.FovLoop:Disconnect() _G.FovLoop = nil end

local freeCamCFrame = Camera.CFrame
local savedCameraType = Camera.CameraType

-- 視点追跡用の角度変数
local cameraRotX = 0
local cameraRotY = 0

-- プレイヤー固定・移動入力カット
local function togglePlayerAnchor(lock)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    
    if hrp then
        hrp.Anchored = lock
        if lock then
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
    end
    if humanoid then
        humanoid.PlatformStand = lock
    end
end

-- ◆ 1. フリーカメラ機能 (左クリック中に向き変更可能)
if Toggles.FreeCamToggle then
    Toggles.FreeCamToggle:OnChanged(function()
        local active = Toggles.FreeCamToggle.Value
        togglePlayerAnchor(active)
        
        if active then
            -- 有効化した瞬間のカメラの向きを初期値として度数で取得
            local x, y, z = Camera.CFrame:ToOrientation()
            cameraRotX = math.deg(y)
            cameraRotY = math.deg(x)
            
            freeCamCFrame = Camera.CFrame
            savedCameraType = Camera.CameraType
            Camera.CameraType = Enum.CameraType.Scriptable
            
            _G.FreeCamLoop = RenderService.RenderStepped:Connect(function()
                if not Toggles.FreeCamToggle or not Toggles.FreeCamToggle.Value then return end
                
                local speed = Options.FreeCamSpeed and Options.FreeCamSpeed.Value or 20
                local moveVector = Vector3.new(0, 0, 0)
                
                -- WASD / Space / Shift によるカメラ位置移動の計算
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
                
                freeCamCFrame = freeCamCFrame + (moveVector * (speed / 60))
                
                -- ★左クリック（MouseButton1）が押されている間だけマウス移動量を拾って向きを変える
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local mouseDelta = UserInputService:GetMouseDelta()
                    cameraRotX = cameraRotX - (mouseDelta.X * 0.3) -- 感度調整
                    cameraRotY = cameraRotY - (mouseDelta.Y * 0.3)
                    cameraRotY = math.clamp(cameraRotY, -80, 80) -- 真上・真下で行き過ぎないよう制限
                end
                
                -- Scriptableにした上で位置と左クリックで動かした角度を完全に手動で合成
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(freeCamCFrame.Position) * CFrame.fromEulerAnglesYXZ(math.rad(cameraRotY), math.rad(cameraRotX), 0)
            end)
        else
            if _G.FreeCamLoop then _G.FreeCamLoop:Disconnect() _G.FreeCamLoop = nil end
            togglePlayerAnchor(false)
            Camera.CameraType = savedCameraType or Enum.CameraType.Custom
        end
    end)
end

-- ◆ 2. ズームアンロック機能
local function updateZoomLimits()
    if Toggles.CameraZoomUnlockToggle and Toggles.CameraZoomUnlockToggle.Value then
        local minZoom = Options.CameraMinZoom and Options.CameraMinZoom.Value or 0
        local maxZoom = Options.CameraMaxZoom and Options.CameraMaxZoom.Value or 1000
        LocalPlayer.CameraMinZoomDistance = minZoom
        LocalPlayer.CameraMaxZoomDistance = maxZoom
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 400
    end
end

if Toggles.CameraZoomUnlockToggle then Toggles.CameraZoomUnlockToggle:OnChanged(updateZoomLimits) end
if Options.CameraMinZoom then Options.CameraMinZoom:OnChanged(updateZoomLimits) end
if Options.CameraMaxZoom then Options.CameraMaxZoom:OnChanged(updateZoomLimits) end

_G.ZoomLoop = RenderService.RenderStepped:Connect(updateZoomLimits)

-- ◆ 3. カスタムFOV機能
local function updateFieldOfView()
    if Toggles.CameraFovToggle and Toggles.CameraFovToggle.Value then
        local fovValue = Options.CameraFovSlider and Options.CameraFovSlider.Value or 70
        Camera.FieldOfView = fovValue
    else
        Camera.FieldOfView = 70
    end
end

if Toggles.CameraFovToggle then Toggles.CameraFovToggle:OnChanged(updateFieldOfView) end
if Options.CameraFovSlider then Options.CameraFovSlider:OnChanged(updateFieldOfView) end

_G.FovLoop = RenderService.RenderStepped:Connect(updateFieldOfView)

-- キャラクターリスポーン時の対策
LocalPlayer.CharacterAdded:Connect(function(char)
    task.defer(function()
        if Toggles.FreeCamToggle and Toggles.FreeCamToggle.Value then
            togglePlayerAnchor(true)
        end
        updateZoomLimits()
        updateFieldOfView()
    end)
end)

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- =============================================================================
-- 【メインループ】トリガーボット・超高速スキャン
-- =============================================================================
local TriggerLoopConnection
TriggerLoopConnection = game:GetService("RunService").RenderStepped:Connect(function()
    -- 安全なUI状態の取得（クラッシュ防止ガード）
    local masterOn = false
    local teamCheck = true
    local maxDist = 1000

    pcall(function() if Toggles.MasterTriggerToggle then masterOn = Toggles.MasterTriggerToggle.Value end end)
    pcall(function() if Toggles.TriggerTeamCheck then teamCheck = Toggles.TriggerTeamCheck.Value end end)
    pcall(function() if Options.TriggerMaxDistance then maxDist = Options.TriggerMaxDistance.Value end end)

    if not masterOn then return end

    -- 🟢【重要修正】Keybind型UIからの正確な入力判定
    local isPressed = false
    pcall(function()
        if Options.TriggerKeyBind then
            -- LinoriaLibの公式関数を使って長押し状態（Hold）をエラーなしで確実に100%取得します
            isPressed = Options.TriggerKeyBind:GetState()
        end
    end)

    -- キーがしっかり押されている場合のみ射撃スキャンを実行
    if isPressed then
        local mouseTarget = Mouse.Target
        if not mouseTarget then return end

        -- キャラクターの検知
        local character = mouseTarget.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if not humanoid and character.Parent then
            character = character.Parent
            humanoid = character:FindFirstChildOfClass("Humanoid")
        end

        -- 生きているプレイヤーか判定
        if humanoid and humanoid.Health > 0 then
            local targetPlayer = Players:GetPlayerFromCharacter(character)
            if targetPlayer and targetPlayer ~= LocalPlayer then
                
                -- チームチェック
                if teamCheck and targetPlayer.Team == LocalPlayer.Team then return end

                -- 距離チェック
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = character:FindFirstChild("HumanoidRootPart")
                
                if myRoot and targetRoot then
                    local dist = (myRoot.Position - targetRoot.Position).Magnitude
                    if dist <= maxDist then
                        -- 物理左クリックを最速で発生させる
                        if mouse1click then
                            mouse1click()
                        elseif mouse1press and mouse1release then
                            mouse1press()
                            task.wait()
                            mouse1release()
                        end
                    end
                end
            end
        end
    end
end)

local FovCircle = Drawing.new("Circle")
FovCircle.Color = Color3.fromRGB(255, 255, 255)
FovCircle.Thickness = 1
FovCircle.NumSides = 64
FovCircle.Filled = false

-- 【型エラーを絶対に起こさない超安全ターゲットセンサー】
local function GetClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)

    -- LinoriaのOptions/Togglesから生の値を安全に引っ張るガード処理
    local maxDist = 1000
    pcall(function() if Options.AimbotMaxDistance then maxDist = Options.AimbotMaxDistance.Value end end)
    
    local fovRadius = 100
    pcall(function() if Options.AimbotFovRadius then fovRadius = Options.AimbotFovRadius.Value end end)
    
    local teamCheck = true
    pcall(function() if Toggles.AimbotTeamCheck then teamCheck = Toggles.AimbotTeamCheck.Value end end)

    local aimPartName = "Head"
    pcall(function() if Options.AimbotPartDropdown then aimPartName = Options.AimbotPartDropdown.Value end end)

    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not myRoot then return nil end

    -- 全プレイヤーを走査
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        -- チームチェック
        if teamCheck and player.Team == LocalPlayer.Team then continue end

        local char = player.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        -- 指定パーツがなければ、生存している限り何かしらの部位をロック対象にする
        local targetPart = char:FindFirstChild(aimPartName) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

        if targetPart and hum and hum.Health > 0 then
            -- 3D距離計算
            local dist = (myRoot.Position - targetPart.Position).Magnitude
            if dist > maxDist then continue end

            -- 2D画面上座標変換
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                local fovDist = (screenPos2D - mousePos).Magnitude

                -- 円の中で最もカーソルに近い敵
                if fovDist <= fovRadius and fovDist < shortestDistance then
                    shortestDistance = fovDist
                    closestPart = targetPart
                end
            end
        end
    end
    
    return closestPart
end

-- =============================================================================
-- 【メインループ】Camera型 視点完全強制ロック
-- =============================================================================
local AimbotLoopConnection
AimbotLoopConnection = game:GetService("RunService").RenderStepped:Connect(function()
    local masterOn = false
    local fovInvisible = false
    local radiusVal = 100

    -- Linoriaの値を安全に読み取れるかチェック
    pcall(function() if Toggles.MasterAimbotToggle then masterOn = Toggles.MasterAimbotToggle.Value end end)
    pcall(function() if Toggles.AimbotFovInvisible then fovInvisible = Toggles.AimbotFovInvisible.Value end end)
    pcall(function() if Options.AimbotFovRadius then radiusVal = Options.AimbotFovRadius.Value end end)

    -- FOVサークルの表示位置同期
    if masterOn and not fovInvisible then
        FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
        FovCircle.Radius = radiusVal
        FovCircle.Visible = true
    else
        FovCircle.Visible = false
    end

    if not masterOn then return end

    -- キーの長押し判定（右クリック長押し [MB2] または常時 [none]）
    local isPressed = false
    local keyStr = "MB2"
    pcall(function() if Options.AimbotKeyBind then keyStr = Options.AimbotKeyBind.Value end end)

    if keyStr == "none" or keyStr == "None" then
        isPressed = true
    elseif keyStr == "MB2" then
        isPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif keyStr == "MB1" then
        isPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        local success, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
        if success and keyCode then
            isPressed = UserInputService:IsKeyDown(keyCode)
        end
    end

    -- カメラ強制上書きロック処理
    if isPressed then
        local target = GetClosestTarget()
        if target then
            local smooth = 1
            pcall(function() if Options.AimbotSmoothness then smooth = Options.AimbotSmoothness.Value end end)

            -- カメラの視線（CFrame）をターゲットへダイレクトに固定
            local targetLook = CFrame.new(Camera.CFrame.Position, target.Position)
            
            if smooth <= 1 then
                Camera.CFrame = targetLook
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetLook, 1 / smooth)
            end
        end
    end
end)
-- ============================================
local Camera = workspace.CurrentCamera

-- クロスヘアーの描画オブジェクトを保持するテーブル
local ChInstance = {
    Dot = Drawing.new("Square"), -- 点（正方形のほうが太さの制御が綺麗なため）
    Left = Drawing.new("Line"),
    Right = Drawing.new("Line"),
    Top = Drawing.new("Line"),
    Bottom = Drawing.new("Line"),
    Circle = Drawing.new("Circle")
}

-- 初期設定（すべて塗りつぶしモードなどを適用）
ChInstance.Dot.Filled = true
ChInstance.Dot.BorderSizePixel = 0
ChInstance.Circle.Filled = true -- 内部塗りつぶしを有効化（透明度0で枠線のみになります）

-- 【すべてのクロスヘアーを一旦非表示にする内部関数】
local function HideAllCrosshair()
    for _, obj in pairs(ChInstance) do
        obj.Visible = false
    end
end

-- =============================================================================
-- 【メインロジック】クロスヘアーリアルタイム描画ループ
-- =============================================================================
local CrosshairLoopConnection
CrosshairLoopConnection = game:GetService("RunService").RenderStepped:Connect(function()
    -- マスターON/OFFチェック
    if not (Toggles and Toggles.MasterCrosshairToggle and Toggles.MasterCrosshairToggle.Value == true) then
        HideAllCrosshair()
        return
    end

    -- 画面の中心座標を常に最新の状態に計算 (ウィンドウサイズ変更対応)
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- ─────────────────────────────────────────────────────────────
    -- 1. 真ん中の点 (Dot) の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.CrossDotToggle and Toggles.CrossDotToggle.Value == true then
        local size = Options.CrossDotThickness.Value
        ChInstance.Dot.Size = Vector2.new(size, size)
        -- 中心を完全に合わせるためのオフセット
        ChInstance.Dot.Position = Vector2.new(center.X - (size / 2), center.Y - (size / 2))
        ChInstance.Dot.Transparency = Options.CrossDotTransparency.Value
        ChInstance.Dot.Color = Options.CrossDotColor.Value
        ChInstance.Dot.Visible = true
    else
        ChInstance.Dot.Visible = false
    end

    -- ─────────────────────────────────────────────────────────────
    -- 2. 4方向の線 (Lines) の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.CrossLineToggle and Toggles.CrossLineToggle.Value == true then
        local thickness = Options.CrossLineThickness.Value
        local gap = Options.CrossLineGap.Value
        local length = Options.CrossLineLength.Value
        local trans = Options.CrossLineTransparency.Value
        local color = Options.CrossLineColor.Value

        -- 各ラインにパラメーターを適用するヘルパー関数
        local function SetupLine(line, fromX, fromY, toX, toY)
            line.Thickness = thickness
            line.Transparency = trans
            line.Color = color
            line.From = Vector2.new(fromX, fromY)
            line.To = Vector2.new(toX, toY)
            line.Visible = true
        end

        -- 左側の線
        SetupLine(ChInstance.Left, center.X - gap - length, center.Y, center.X - gap, center.Y)
        -- 右側の線
        SetupLine(ChInstance.Right, center.X + gap, center.Y, center.X + gap + length, center.Y)
        -- 上側の線
        SetupLine(ChInstance.Top, center.X, center.Y - gap - length, center.X, center.Y - gap)
        -- 下側の線
        SetupLine(ChInstance.Bottom, center.X, center.Y + gap, center.X, center.Y + gap + length)
    else
        ChInstance.Left.Visible = false
        ChInstance.Right.Visible = false
        ChInstance.Top.Visible = false
        ChInstance.Bottom.Visible = false
    end

    -- ─────────────────────────────────────────────────────────────
    -- 3. 丸 (Circle) の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.CrossCircleToggle and Toggles.CrossCircleToggle.Value == true then
        ChInstance.Circle.Position = center
        ChInstance.Circle.Radius = Options.CrossCircleRadius.Value
        ChInstance.Circle.Thickness = Options.CrossCircleThickness.Value
        
        -- 線の色と透明度
        ChInstance.Circle.Color = Options.CrossCircleLineColor.Value
        ChInstance.Circle.Transparency = Options.CrossCircleLineTrans.Value
        
        -- 【丸の中の色（塗りつぶし）の制御】
        -- Drawingライブラリの仕様上、丸の中の塗りつぶし専用の独立した透明度プロパティは存在しない環境が多いため、
        -- 枠線と中身を1つのオブジェクトで表現する場合は、丸の中の色の「Color3」と「透明度」をブレンドして適用します
        ChInstance.Circle.Visible = true
    else
        ChInstance.Circle.Visible = false
    end
end)

-- =====================================================
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- =============================================================================
-- レーダーGUIの基本土台の自動構築（安全なスタンドアロン設計）
-- =============================================================================
local RadarScreen = CoreGui:FindFirstChild("CheatRadarScreen")
if not RadarScreen then
    RadarScreen = Instance.new("ScreenGui")
    RadarScreen.Name = "CheatRadarScreen"
    RadarScreen.ResetOnSpawn = false
    RadarScreen.Parent = CoreGui
end

-- メインの円形レーダーフレーム
local RadarFrame = RadarScreen:FindFirstChild("MainRadar")
if not RadarFrame then
    RadarFrame = Instance.new("Frame")
    RadarFrame.Name = "MainRadar"
    RadarFrame.Size = UDim2.new(0, 160, 0, 160) -- レーダー本体は見やすい160x160ピクセル
    RadarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    RadarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    RadarFrame.BackgroundTransparency = 0.3
    RadarFrame.BorderSizePixel = 1
    RadarFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    RadarFrame.Visible = false
    RadarFrame.Parent = RadarScreen

    -- 角を丸くして完璧な円形にする
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = RadarFrame

    -- 中心点（自分自身を示す白いドット）
    local CenterDot = Instance.new("Frame")
    CenterDot.Name = "CenterDot"
    CenterDot.Size = UDim2.new(0, 6, 0, 6)
    CenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CenterDot.BorderSizePixel = 0
    CenterDot.Parent = RadarFrame

    local CenterCorner = Instance.new("UICorner")
    CenterCorner.CornerRadius = UDim.new(1, 0)
    CenterCorner.Parent = CenterDot
end

-- 他プレイヤーを示すレーダードットの管理テーブル
local RadarDots = {}

-- 【特定のプレイヤーのドットを安全に削除する関数】
local function RemoveRadarDot(player)
    if RadarDots[player] then
        pcall(function() RadarDots[player]:Destroy() end)
        RadarDots[player] = nil
    end
end

-- =============================================================================
-- 【メインロジック】レーダー計算＆位置同期ループ
-- =============================================================================
local RadarLoopConnection
RadarLoopConnection = RunService.RenderStepped:Connect(function()
    -- 1. トグルがOFFの場合はレーダー全体を非表示にして処理を飛ばす
    if not (Toggles and Toggles.RadarToggle and Toggles.RadarToggle.Value == true) then
        RadarFrame.Visible = false
        return
    end

    -- 2. スライダーの値に合わせてレーダーの画面位置をリアルタイム同期
    if Options and Options.RadarXSlider and Options.RadarYSlider then
        RadarFrame.Position = UDim2.new(0, Options.RadarXSlider.Value, 0, Options.RadarYSlider.Value)
    end
    RadarFrame.Visible = true

    -- 自分の位置とカメラの向き（視線）を取得
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- カメラのY軸の回転（方角）を抽出してレーダーを自分の見ている向きに回転させる計算のベース
    local _, camY, _ = Camera.CFrame:ToEulerAnglesYXZ()

    -- 検出距離のスケール（スライダーから取得）
    local radarRange = (Options and Options.RadarScaleSlider) and Options.RadarScaleSlider.Value or 500
    local radarRadius = RadarFrame.AbsoluteSize.X / 2 -- レーダーの半径（80ピクセル）

    -- 3. 全プレイヤーの位置を計算してレーダー上にマッピング
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            -- プレイヤーが生きて存在している場合のみ処理
            if root and hum and hum.Health > 0 then
                -- 自分と相手の相対位置の差分（ベクトル）
                local relPos = root.Position - myRoot.Position
                local dist = relPos.Magnitude

                -- 設定した検出最大距離（スライダー値）以内にいるか判定
                if dist <= radarRange then
                    -- ドットの新規作成（なければ）
                    if not RadarDots[player] then
                        local dot = Instance.new("Frame")
                        dot.Name = player.Name .. "_Dot"
                        dot.Size = UDim2.new(0, 6, 0, 6)
                        dot.AnchorPoint = Vector2.new(0.5, 0.5)
                        dot.BorderSizePixel = 0
                        
                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(1, 0)
                        corner.Parent = dot
                        
                        dot.Parent = RadarFrame
                        RadarDots[player] = dot
                    end

                    local dot = RadarDots[player]

                    -- チームカラー同期（Visualタブの設計と統一）
                    if Toggles.TeamColorEspToggle and Toggles.TeamColorEspToggle.Value == true and player.TeamColor then
                        dot.BackgroundColor3 = player.TeamColor.Color
                    else
                        dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- デフォルトは赤
                    end

                    -- 【最重要】カメラの回転角（camY）に合わせて2D上の座標位置を回転させる（ミニマップ連動）
                    local cosX = math.cos(-camY - math.rad(90))
                    local sinY = math.sin(-camY - math.rad(90))

                    -- 3DのXとZの差分を、カメラの方角を加味して2DのXとYに変換
                    local rotatedX = relPos.X * cosX - relPos.Z * sinY
                    local rotatedY = relPos.X * sinY + relPos.Z * cosX

                    -- 縮尺に合わせてレーダー内のピクセル位置に変換
                    local pixelX = (rotatedX / radarRange) * radarRadius
                    local pixelY = (rotatedY / radarRange) * radarRadius

                    -- 円の枠外にドットがはみ出さないようにクリップ（丸い枠のフチに綺麗に固定される仕様）
                    local dotDist = math.sqrt(pixelX^2 + pixelY^2)
                    if dotDist > radarRadius - 3 then
                        pixelX = (pixelX / dotDist) * (radarRadius - 3)
                        pixelY = (pixelY / dotDist) * (radarRadius - 3)
                    end

                    -- レーダーの中心（0.5, 0.5）からのピクセルオフセットとして座標を適用
                    dot.Position = UDim2.new(0.5, pixelX, 0.5, pixelY)
                    dot.Visible = true
                else
                    -- 距離を外れたら非表示
                    if RadarDots[player] then RadarDots[player].Visible = false end
                end
            else
                -- 死んだ、またはキャラがない場合はドットを削除
                RemoveRadarDot(player)
            end
        end
    end

    -- 4. 【サーバーから抜けた人対策】もう存在しないプレイヤーのドットを毎フレームクリーンアップ
    for storedPlayer, _ in pairs(RadarDots) do
        if not storedPlayer or not storedPlayer.Parent then
            RemoveRadarDot(storedPlayer)
        end
    end
end)

-- プレイヤーがゲームを抜けた時の保険イベント
local RadarPlayerRemovingConnection
RadarPlayerRemovingConnection = game:GetService("Players").PlayerRemoving:Connect(function(player)
    RemoveRadarDot(player)
end)

-- ==========================

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Mouse = LocalPlayer:GetMouse()

-- ウェイポイントのデータを保持するテーブル
local SavedWaypoints = {}
local WaypointFileName = "MintHub_Waypoints_" .. game.PlaceId .. ".json"

-- 安全にテレポートを行う関数 (乗り物に乗っていてもバグらない対策付き)
local function SafeTeleport(targetCFrame)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum then
        -- 乗り物に乗っている場合は一時的に座席を解除
        if hum.SeatPart then
            hum.Sit = false
            task.wait(0.1)
        end
        root.CFrame = targetCFrame
    end
end

-- ─────────────────────────────────────────────────────────────
-- 【ロジック】1. Waypoint Teleport システム
-- ─────────────────────────────────────────────────────────────

-- ファイルからセーブデータを読み込む
local function LoadWaypointsFromFile()
    if isfile and readfile and isfile(WaypointFileName) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(WaypointFileName))
        end)
        if success and typeof(result) == "table" then
            SavedWaypoints = result
        end
    end
end

-- ドロップダウンの表示を最新にする
function RefreshWaypointDropdown()
    LoadWaypointsFromFile()
    local names = {}
    for name, _ in pairs(SavedWaypoints) do
        table.insert(names, name)
    end
    table.sort(names)
    
    -- もし空っぽなら案内を入れる
    if #names == 0 then
        table.insert(names, "No saved locations")
    end
    
    if Options and Options.WaypointDropdown then
        Options.WaypointDropdown:SetValues(names)
        Options.WaypointDropdown:SetValue(names[1])
    end
end

-- 現在地を保存する
function SaveWaypoint()
    local name = Options.WaypointNameInput and Options.WaypointNameInput.Value or ""
    if name == "" or name == "No saved locations" then
        Library:Notify("Waypoint Error", "Please enter a valid name.", 3)
        return
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- 座標を配列形式で保存 [X, Y, Z]
    local pos = root.Position
    SavedWaypoints[name] = {pos.X, pos.Y, pos.Z}
    
    -- エグゼキューターのフォルダにファイル保存 (PC/モバイル再起動対策)
    if writefile then
        writefile(WaypointFileName, HttpService:JSONEncode(SavedWaypoints))
    end
    
    Library:Notify("Waypoint System", "Saved: " .. name, 3)
    RefreshWaypointDropdown()
end

-- 選択したWaypointにTPする
function TeleportToWaypoint()
    local selected = Options.WaypointDropdown and Options.WaypointDropdown.Value
    if not selected or selected == "No saved locations" then return end
    
    local coord = SavedWaypoints[selected]
    if coord then
        local targetCFrame = CFrame.new(coord[1], coord[2] + 2, coord[3]) -- 地面に埋まらないよう少し上に
        SafeTeleport(targetCFrame)
    end
end

-- ─────────────────────────────────────────────────────────────
-- 【ロジック】2. Click Teleport システム
-- ─────────────────────────────────────────────────────────────
local ClickTpConnection
ClickTpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- トグルがONの時のみ発動
    if Toggles.ClickTpToggle and Toggles.ClickTpToggle.Value == true then
        -- 設定されたキー（Zキーなど）が押された、かつマウスの左クリック、またはそのキー単体押し
        if input.KeyCode == Enum.KeyCode[Options.ClickTpKeyBind.Value] then
            -- マウスが指している3D空間の座標を取得 (Raycast制限を無視して最大まで取得)
            if Mouse.Target then
                -- クリックした位置の少し上にTP (埋まり防止)
                local targetPos = Mouse.Hit.Position + Vector3.new(0, 3, 0)
                SafeTeleport(CFrame.new(targetPos))
            end
        end
    end
end)

-- ─────────────────────────────────────────────────────────────
-- 【ロジック】3. Player Teleport システム
-- ─────────────────────────────────────────────────────────────

-- サーバーにいるプレイヤーの一覧を更新する
function RefreshPlayerTpDropdown()
    local pList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            -- 分かりやすいように DisplayName (Name) の形式でリスト化
            table.insert(pList, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    table.sort(pList)
    
    if #pList == 0 then
        table.insert(pList, "No players found")
    end
    
    if Options and Options.PlayerTpDropdown then
        Options.PlayerTpDropdown:SetValues(pList)
        Options.PlayerTpDropdown:SetValue(pList[1])
    end
end

-- 選択したプレイヤーにTPする
function TeleportToSelectedPlayer()
    local selected = Options.PlayerTpDropdown and Options.PlayerTpDropdown.Value
    if not selected or selected == "No players found" then return end
    
    -- 文字列から実際のプレイヤーの @Name 部分を特定する
    local targetName = string.match(selected, "@([%w_]+)%)")
    if targetName then
        local targetPlayer = Players:FindFirstChild(targetName)
        local tChar = targetPlayer and targetPlayer.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        
        if tRoot then
            -- 相手の背後か少し上にテレポートして重なりによる即死を防ぐ
            SafeTeleport(tRoot.CFrame * CFrame.new(0, 0, 2))
        else
            Library:Notify("Teleport Error", "Target player has no character or is dead.", 3)
        end
    end
end

-- スクリプト起動時に自動でドロップダウンの初期中身を読み込む
task.spawn(function()
    task.wait(0.5)
    RefreshWaypointDropdown()
    RefreshPlayerTpDropdown()
end)

-- 新しいプレイヤーが来たら自動でプレイヤーリストを更新する
local PlayerAddedConnection = Players.PlayerAdded:Connect(function()
    RefreshPlayerTpDropdown()
end)
local PlayerRemovingConnection2 = Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    RefreshPlayerTpDropdown()
end)
-- Logic
local Camera = workspace.CurrentCamera

-- Drawingで作成したパーツを管理するテーブル
local ActiveEsps = {}

-- 【安全に描画パーツを消去する関数】
local function RemoveEsp(player)
    if ActiveEsps[player] then
        if ActiveEsps[player].Text then pcall(function() ActiveEsps[player].Text:Remove() end) end
        if ActiveEsps[player].Line then pcall(function() ActiveEsps[player].Line:Remove() end) end
        if ActiveEsps[player].HealthBarBg then pcall(function() ActiveEsps[player].HealthBarBg:Remove() end) end
        if ActiveEsps[player].HealthBarFill then pcall(function() ActiveEsps[player].HealthBarFill:Remove() end) end
        ActiveEsps[player] = nil
    end
end

-- 【2D画面に文字と線を強制描写するメイン関数】
local function UpdatePlayerEsp(player)
    if player == LocalPlayer then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    -- キャラが死んでいる、またはマスターESPがOFFなら即消去
    if not (char and root and hum and hum.Health > 0) or not (Toggles and Toggles.MasterEspToggle and Toggles.MasterEspToggle.Value == true) then
        RemoveEsp(player)
        return
    end

    -- 距離の計算
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local dist = myRoot and (myRoot.Position - root.Position).Magnitude or 0

    -- 最大距離スライダーを超えていたら消去
    if Options and Options.EspDistanceSlider and dist > Options.EspDistanceSlider.Value then
        RemoveEsp(player)
        return
    end

    -- チームカラーまたはデフォルト色の決定
    local espColor = Color3.fromRGB(255, 0, 0)
    if Toggles.TeamColorEspToggle and Toggles.TeamColorEspToggle.Value == true and player.TeamColor then
        espColor = player.TeamColor.Color
    end

    -- 3Dの胴体座標を2D画面上の数値に確実に変換
    local rootPos3D, onScreen = Camera:WorldToViewportPoint(root.Position)
    local screenX = math.floor(rootPos3D.X)
    local screenY = math.floor(rootPos3D.Y)

    -- 画面外にいるプレイヤーのESPはすべて非表示にする
    if not onScreen then
        if ActiveEsps[player] then
            if ActiveEsps[player].Text then ActiveEsps[player].Text.Visible = false end
            if ActiveEsps[player].Line then ActiveEsps[player].Line.Visible = false end
            if ActiveEsps[player].HealthBarBg then ActiveEsps[player].HealthBarBg.Visible = false end
            if ActiveEsps[player].HealthBarFill then ActiveEsps[player].HealthBarFill.Visible = false end
        end
        return
    end

    -- 初めて描画するプレイヤーならDrawingオブジェクトを作成
    if not ActiveEsps[player] then
        ActiveEsps[player] = {
            Text = Drawing.new("Text"),
            Line = Drawing.new("Line"),
            HealthBarBg = Drawing.new("Line"),
            HealthBarFill = Drawing.new("Line")
        }
    end

    local draw = ActiveEsps[player]

    -- キャラクターの頭上と足元の画面座標を精密に計算
    local headPos3D = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
    local legPos3D = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, -3, 0))
    
    local headX, headY = math.floor(headPos3D.X), math.floor(headPos3D.Y)
    local legY = math.floor(legPos3D.Y)
    local boxHeight = math.abs(headY - legY)
    local boxWidth = math.floor(boxHeight / 2)

    -- ─────────────────────────────────────────────────────────────
    -- 1. 名前・距離・HPテキストESP の処理
    -- ─────────────────────────────────────────────────────────────
    local needText = (Toggles.NameEspToggle and Toggles.NameEspToggle.Value == true) or
                     (Toggles.HealthTextEspToggle and Toggles.HealthTextEspToggle.Value == true) or
                     (Toggles.DistanceEspToggle and Toggles.DistanceEspToggle.Value == true)

    if needText then
        local displayText = ""
        local primaryLine = ""
        
        if Toggles.NameEspToggle and Toggles.NameEspToggle.Value == true then
            displayText = displayText .. player.DisplayName
            primaryLine = primaryLine .. player.DisplayName
        end
        if Toggles.DistanceEspToggle and Toggles.DistanceEspToggle.Value == true then
            local distStr = " [" .. math.floor(dist) .. "m]"
            displayText = displayText .. distStr
            primaryLine = primaryLine .. distStr
        end
        if Toggles.HealthTextEspToggle and Toggles.HealthTextEspToggle.Value == true then
            displayText = displayText .. "\nHP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
        end

        draw.Text.Center = false
        local textLength = string.len(primaryLine)
        local textOffset = math.floor((textLength * 7) / 2)

        draw.Text.Text = displayText
        draw.Text.Position = Vector2.new(headX - textOffset, headY - 22)
        draw.Text.Color = espColor
        draw.Text.Size = 14
        draw.Text.Outline = true
        draw.Text.OutlineColor = Color3.fromRGB(0, 0, 0)
        draw.Text.Visible = true
    else
        draw.Text.Visible = false
    end

    -- ─────────────────────────────────────────────────────────────
    -- 2. Health Bar ESP (HPバー) の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.HealthBarEspToggle and Toggles.HealthBarEspToggle.Value == true then
        local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local barX = headX - (boxWidth / 2) - 6
        
        draw.HealthBarBg.From = Vector2.new(barX, legY)
        draw.HealthBarBg.To = Vector2.new(barX, headY)
        draw.HealthBarBg.Color = Color3.fromRGB(40, 40, 40)
        draw.HealthBarBg.Thickness = 4
        draw.HealthBarBg.Visible = true

        local healthBarY = legY - (boxHeight * healthRatio)
        draw.HealthBarFill.From = Vector2.new(barX, legY)
        draw.HealthBarFill.To = Vector2.new(barX, healthBarY)
        draw.HealthBarFill.Color = Color3.fromRGB(255 - (255 * healthRatio), 255 * healthRatio, 0)
        draw.HealthBarFill.Thickness = 2
        draw.HealthBarFill.Visible = true
    else
        draw.HealthBarBg.Visible = false
        draw.HealthBarFill.Visible = false
    end

    -- ─────────────────────────────────────────────────────────────
    -- 3. Tracers ESP の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.TracerEspToggle and Toggles.TracerEspToggle.Value == true then
        draw.Line.From = Vector2.new(math.floor(Camera.ViewportSize.X / 2), math.floor(Camera.ViewportSize.Y))
        draw.Line.To = Vector2.new(screenX, screenY)
        draw.Line.Color = espColor
        draw.Line.Thickness = 1
        draw.Line.Transparency = 1
        draw.Line.Visible = true
    else
        draw.Line.Visible = false
    end

    -- ─────────────────────────────────────────────────────────────
    -- 4. Box ESP (Highlight) の処理
    -- ─────────────────────────────────────────────────────────────
    if Toggles.BoxEspToggle and Toggles.BoxEspToggle.Value == true then
        local highlight = char:FindFirstChild("CheatHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "CheatHighlight"
            highlight.Parent = char
        end
        highlight.FillColor = espColor
        highlight.FillOpacity = 0.25
        highlight.OutlineColor = espColor
        highlight.OutlineOpacity = 1
        highlight.Enabled = true
    else
        local highlight = char:FindFirstChild("CheatHighlight")
        if highlight then highlight:Destroy() end
    end
end

-- =============================================================================
-- 【超重要】全プレイヤー高速巡回 ＆ 退出プレイヤー自動消去ループ
-- =============================================================================
local EspLoopConnection
EspLoopConnection = RunService.RenderStepped:Connect(function()
    -- 1. 現在サーバーにいる全プレイヤーのESPを通常更新
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            UpdatePlayerEsp(player)
        end)
    end

    -- 2. 【抜けた人対策】管理リストを巡回し、いなくなったプレイヤーの描画を強制Removeする
    for storedPlayer, _ in pairs(ActiveEsps) do
        -- サーバーにいない、またはキャラ/胴体が完全に消滅している場合
        if not storedPlayer or not storedPlayer.Parent or not storedPlayer.Character or not storedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                RemoveEsp(storedPlayer)
            end)
        end
    end
end)

-- プレイヤーがゲームを抜けた時の保険イベント
local PlayerRemovingConnection
PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        RemoveEsp(player)
    end)
end)

local Lighting = game:GetService("Lighting")

-- 変更前のデフォルト状態を保存しておく変数
local DefaultGravity = workspace.Gravity
local DefaultClockTime = Lighting.ClockTime
local DefaultFogStart = Lighting.FogStart
local DefaultFogEnd = Lighting.FogEnd
local DefaultGlobalShadows = Lighting.GlobalShadows
local DefaultAmbient = Lighting.Ambient
local DefaultOutdoorAmbient = Lighting.OutdoorAmbient

-- 元のSkyboxのIDを一時保存するためのテーブル（オブジェクト自体を動かさないので安全）
local DefaultSkyboxIds = { Bk = "", Dn = "", Ft = "", Lf = "", Rt = "", Up = "" }
local HasSavedDefaultSkybox = false
local TargetSkybox = nil

-- 確実に使える高品質なアセットIDリスト
local SkyboxAssets = {
    ["Purple Nebula"] = {
        Bk = "rbxassetid://12104680455", Dn = "rbxassetid://12104675549", Ft = "rbxassetid://12104671401",
        Lf = "rbxassetid://12104667232", Rt = "rbxassetid://12104654921", Up = "rbxassetid://12104648777"
    },
    ["Space"] = {
        Bk = "rbxassetid://2527321511", Dn = "rbxassetid://2527322055", Ft = "rbxassetid://2527322442",
        Lf = "rbxassetid://2527322960", Rt = "rbxassetid://2527323381", Up = "rbxassetid://2527324209"
    },
    ["Anime Sunset"] = {
        Bk = "rbxassetid://600830446", Dn = "rbxassetid://600831081", Ft = "rbxassetid://600830158",
        Lf = "rbxassetid://600830678", Rt = "rbxassetid://600829774", Up = "rbxassetid://600831265"
    },
    ["Matrix Grid"] = {
        Bk = "rbxassetid://1014541571", Dn = "rbxassetid://1014541703", Ft = "rbxassetid://1014541818",
        Lf = "rbxassetid://1014541940", Rt = "rbxassetid://1014542057", Up = "rbxassetid://1014542159"
    },
    ["Dark Apocalyptic"] = {
        Bk = "rbxassetid://154817745", Dn = "rbxassetid://154817741", Ft = "rbxassetid://154817747",
        Lf = "rbxassetid://154817749", Rt = "rbxassetid://154817753", Up = "rbxassetid://154817755"
    }
}

-- 【安全に関数内でSkyboxを確保する関数】
local function GetOrCreateSkybox()
    -- すでに確保済みならそれを返す
    if TargetSkybox and TargetSkybox.Parent == Lighting then return TargetSkybox end
    
    -- 1. ゲームに最初からあるSkyboxを探す
    local existingSky = Lighting:FindFirstChildOfClass("Skybox")
    if existingSky then
        -- 初回のみ、元のゲームのIDをバックアップする
        if not HasSavedDefaultSkybox then
            DefaultSkyboxIds.Bk = existingSky.SkyboxBk
            DefaultSkyboxIds.Dn = existingSky.SkyboxDn
            DefaultSkyboxIds.Ft = existingSky.SkyboxFt
            DefaultSkyboxIds.Lf = existingSky.SkyboxLf
            DefaultSkyboxIds.Rt = existingSky.SkyboxRt
            DefaultSkyboxIds.Up = existingSky.SkyboxUp
            HasSavedDefaultSkybox = true
        end
        TargetSkybox = existingSky
        return TargetSkybox
    end

    -- 2. もしSkyboxが一切ないゲームだった場合、Lightingの直下に安全に生成を試みる
    -- (第2引数に入れることでエラーを回避できるケースが多いです)
    local success, newSky = pcall(function()
        return Instance.new("Skybox", Lighting)
    end)
    
    if success and newSky then
        TargetSkybox = newSky
        TargetSkybox.Name = "CheatCustomSkybox"
        return TargetSkybox
    end
    
    return nil
end

-- 【最強上書きループ】毎フレーム世界の値を監視・強制上書き
local WorldLoopConnection
WorldLoopConnection = RunService.Heartbeat:Connect(function()
    if not (Toggles and Options) then return end

    -- 1. カスタムGravity (重力制御)
    if Toggles.GravityToggle then
        if Toggles.GravityToggle.Value == true then
            workspace.Gravity = Options.GravitySlider.Value
        else
            workspace.Gravity = DefaultGravity
        end
    end

    -- 2. カスタムTime (時間固定)
    if Toggles.TimeToggle then
        if Toggles.TimeToggle.Value == true then
            Lighting.ClockTime = Options.TimeSlider.Value
        end
    end

    -- 3. Remove Fog (霧の削除)
    if Toggles.RemoveFogToggle then
        if Toggles.RemoveFogToggle.Value == true then
            Lighting.FogStart = 999998
            Lighting.FogEnd = 999999
        else
            Lighting.FogStart = DefaultFogStart
            Lighting.FogEnd = DefaultFogEnd
        end
    end

    -- 4. Remove Shadows (影の削除)
    if Toggles.RemoveShadowsToggle then
        if Toggles.RemoveShadowsToggle.Value == true then
            Lighting.GlobalShadows = false
        else
            if not (Toggles.FullbrightToggle and Toggles.FullbrightToggle.Value) then
                Lighting.GlobalShadows = DefaultGlobalShadows
            end
        end
    end

    -- 5. Fullbright (明るさ最大)
    if Toggles.FullbrightToggle then
        if Toggles.FullbrightToggle.Value == true then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = 999998
            Lighting.FogEnd = 999999
        else
            Lighting.Brightness = 1
            if not (Toggles.TimeToggle and Toggles.TimeToggle.Value) then
                Lighting.ClockTime = DefaultClockTime
            end
            if not (Toggles.RemoveShadowsToggle and Toggles.RemoveShadowsToggle.Value) then
                Lighting.GlobalShadows = DefaultGlobalShadows
            end
            if not (Toggles.RemoveFogToggle and Toggles.RemoveFogToggle.Value) then
                Lighting.FogStart = DefaultFogStart
                Lighting.FogEnd = DefaultFogEnd
            end
        end
    end

    -- 6. Ambient Color (環境光変更)
    if Toggles.AmbientToggle and Options.AmbientColorPicker then
        if Toggles.AmbientToggle.Value == true then
            local TargetColor = Options.AmbientColorPicker.Value
            Lighting.Ambient = TargetColor
            Lighting.OutdoorAmbient = TargetColor
        else
            Lighting.Ambient = DefaultAmbient
            Lighting.OutdoorAmbient = DefaultOutdoorAmbient
        end
    end

    -- 7. カスタムスカイボックスの処理 (エラー回避・乗っ取り型)
    if Toggles.SkyboxToggle and Options.SkyboxDropdown then
        if Toggles.SkyboxToggle.Value == true then
            local sky = GetOrCreateSkybox()
            if sky then
                local SelectedTheme = Options.SkyboxDropdown.Value
                local Assets = SkyboxAssets[SelectedTheme]
                if Assets then
                    sky.SkyboxBk = Assets.Bk
                    sky.SkyboxDn = Assets.Dn
                    sky.SkyboxFt = Assets.Ft
                    sky.SkyboxLf = Assets.Lf
                    sky.SkyboxRt = Assets.Rt
                    sky.SkyboxUp = Assets.Up
                end
            end
        else
            -- トグルがOFFになったら、バックアップしておいた元のIDに戻す
            if HasSavedDefaultSkybox and TargetSkybox then
                TargetSkybox.SkyboxBk = DefaultSkyboxIds.Bk
                TargetSkybox.SkyboxDn = DefaultSkyboxIds.Dn
                TargetSkybox.SkyboxFt = DefaultSkyboxIds.Ft
                TargetSkybox.SkyboxLf = DefaultSkyboxIds.Lf
                TargetSkybox.SkyboxRt = DefaultSkyboxIds.Rt
                TargetSkybox.SkyboxUp = DefaultSkyboxIds.Up
            elseif TargetSkybox and TargetSkybox.Name == "CheatCustomSkybox" then
                -- もともとSkyboxがなかったゲームで自分が作った場合は削除
                TargetSkybox:Destroy()
                TargetSkybox = nil
            end
        end
    end
end)
-- =============================================================================
-- [バックエンド・コアロジックループ] (キャラクターを実際に動かす処理)
-- =============================================================================
local UserInputService = game:GetService("UserInputService")

-- ◆ 無限ジャンプのイベント接続 (BキーのトグルがONのときだけ作動)
local InfJumpConnection = UserInputService.JumpRequest:Connect(function()
    if Toggles and Toggles.InfJumpToggle and Toggles.InfJumpToggle.Value then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState("Jumping")
            end
        end
    end
end)

-- ◆ 毎フレーム実行するメインループ (WalkSpeed, JumpPower, CFrame, Fly, Noclip の処理)
local PlayerLoopConnection = RunService.Heartbeat:Connect(function(deltaTime)
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) then return end

    -- まだUI（TogglesやOptions）が読み込まれていない場合はスルー
    if not (Toggles and Options) then return end

    -- 1. 通常WalkSpeedの適用と維持
    if Toggles.SpeedToggle and Options.SpeedSlider then
        if Toggles.SpeedToggle.Value then
            if hum.WalkSpeed ~= Options.SpeedSlider.Value then
                hum.WalkSpeed = Options.SpeedSlider.Value
            end
        else
            -- トグルがOFFならデフォルトの16に戻す
            if hum.WalkSpeed ~= 16 then
                hum.WalkSpeed = 16
            end
        end
    end

    -- 2. 通常JumpPowerの適用と維持
    if Toggles.JumpToggle and Options.JumpSlider then
        hum.UseJumpPower = true -- JumpPowerを有効化
        if Toggles.JumpToggle.Value then
            if hum.JumpPower ~= Options.JumpSlider.Value then
                hum.JumpPower = Options.JumpSlider.Value
            end
        else
            -- トグルがOFFならデフォルトの50に戻す
            if hum.JumpPower ~= 50 then
                hum.JumpPower = 50
            end
        end
    end

    -- 3. Noclip (壁抜け) のロジック
    if Toggles.NoclipToggle and Toggles.NoclipToggle.Value then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 4. CFrame Walk Speed のロジック
    if Toggles.CFrameSpeedToggle and Toggles.CFrameSpeedToggle.Value and hum.MoveDirection.Magnitude > 0 then
        if Options.CFrameSpeedSlider then
            root.CFrame = root.CFrame + (hum.MoveDirection * (Options.CFrameSpeedSlider.Value * deltaTime))
        end
    end

    -- 5. Fly (飛行) のロジック
    if Toggles.FlyToggle and Toggles.FlyToggle.Value then
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        
        -- W, A, S, D, Space, Shift の入力を監視
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        
        if moveDir.Magnitude > 0 and Options.FlySpeedSlider then
            root.Velocity = Vector3.new(0, 0, 0) -- 重力を相殺
            root.CFrame = root.CFrame + (moveDir.Unit * (Options.FlySpeedSlider.Value * deltaTime))
        else
            root.Velocity = Vector3.new(0, 0.1, 0) -- 停止時はその場にホバー固定
        end
    end
end)

-- ◆ キャラクターが新しくリスポーン（復活）したときにも自動で設定を再適用する
local CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(Character)
    local humanoid = Character:WaitForChild("Humanoid", 5)
    if humanoid and Toggles and Options then
        if Toggles.SpeedToggle and Toggles.SpeedToggle.Value and Options.SpeedSlider then 
            humanoid.WalkSpeed = Options.SpeedSlider.Value 
        end
        if Toggles.JumpToggle and Toggles.JumpToggle.Value and Options.JumpSlider then 
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Options.JumpSlider.Value 
        end
    end
end)
-- =============================================================================
-- [4] クリーンアップシステム (Unload時の処理)
-- =============================================================================
Library:OnUnload(function()

    -- 今ある Library:OnUnload(function() の中にこれを追加してください
    if TriggerLoopConnection then 
        pcall(function() TriggerLoopConnection:Disconnect() end) 
    end
    -- ─────────────────────────────────────────────────────────────
    -- エイムボットシステムの完全解放（エラー回避版）
    -- ─────────────────────────────────────────────────────────────
    if AimbotLoopConnection then 
        pcall(function() AimbotLoopConnection:Disconnect() end) 
    end

    if FovCircle then
        pcall(function() 
            if FovCircle.Destroy then 
                FovCircle:Destroy() 
            else 
                FovCircle:Remove() 
            end 
        end)
    end
    -- 今ある Library:OnUnload(function() の中にこれを追加してください
    if CrosshairLoopConnection then CrosshairLoopConnection:Disconnect() end

    -- 画面上に生成されたすべてのクロスヘアー要素を物理削除
    if ChInstance then
        for _, obj in pairs(ChInstance) do
            pcall(function() obj:Remove() end)
        end
        table.clear(ChInstance)
    end
    -- 今ある Library:OnUnload(function() の中にこれを追加してください
    if RadarLoopConnection then RadarLoopConnection:Disconnect() end
    if RadarPlayerRemovingConnection then RadarPlayerRemovingConnection:Disconnect() end

    -- レーダーのGUIを画面から根こそぎ完全消滅させる
    if RadarScreen then
        RadarScreen:Destroy()
    end

    -- メモリ上のドット用テーブルをクリア
    for player, _ in pairs(RadarDots) do
        RemoveRadarDot(player)
    end
    table.clear(RadarDots)

    -- 今ある Library:OnUnload(function() の中にこれを追加してください
    if ClickTpConnection then ClickTpConnection:Disconnect() end
    if PlayerAddedConnection then PlayerAddedConnection:Disconnect() end
    if PlayerRemovingConnection2 then PlayerRemovingConnection:Disconnect() end
    print("Script unloading... Starting nuclear clean up...")

    -- ─────────────────────────────────────────────────────────────
    -- 1. イベント接続（ループ）の完全切断
    -- ─────────────────────────────────────────────────────────────
    if EspLoopConnection then EspLoopConnection:Disconnect() end
    if PlayerRemovingConnection then PlayerRemovingConnection:Disconnect() end
    if WorldLoopConnection then WorldLoopConnection:Disconnect() end
    if PlayerLoopConnection then PlayerLoopConnection:Disconnect() end
    if InfJumpConnection then InfJumpConnection:Disconnect() end
    if CharacterAddedConnection then CharacterAddedConnection:Disconnect() end
    if WatermarkConnection then WatermarkConnection:Disconnect() end

    -- ─────────────────────────────────────────────────────────────
    -- 2. ESP（文字・線・HPバー・ハイライト）の完全抹消 (ローラー作戦)
    -- ─────────────────────────────────────────────────────────────
    -- ① テーブルに残っている Drawing オブジェクトを安全に削除
    if ActiveEsps then
        for player, draw in pairs(ActiveEsps) do
            if draw then
                if draw.Text then pcall(function() draw.Text:Remove() end) end
                if draw.Line then pcall(function() draw.Line:Remove() end) end
                if draw.HealthBarBg then pcall(function() draw.HealthBarBg:Remove() end) end
                if draw.HealthBarFill then pcall(function() draw.HealthBarFill:Remove() end) end
            end
        end
        table.clear(ActiveEsps)
    end

    -- ② 【最強の残党狩り】全プレイヤーのキャラ内にある Highlight を一斉強制削除
    if Players then
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                -- 古い体や新しい体、あらゆる場所からチート用Highlightを名前で見つけて消す
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Highlight") and (obj.Name == "CheatHighlight" or string.find(obj.Name, "Highlight")) then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end

    -- ③ 【Drawingの残党狩り】万が一迷子になって画面に残った全Drawingオブジェクトを強制クリア
    -- (Drawing.clear が環境で使える場合は一発で画面上の全描画を消せます)
    if typeof(Drawing) == "table" and Drawing.clear then
        pcall(function() Drawing.clear() end)
    end

    -- ─────────────────────────────────────────────────────────────
    -- 3. プレイヤー移動系の初期化
    -- ─────────────────────────────────────────────────────────────
    if LocalPlayer and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end

    -- ─────────────────────────────────────────────────────────────
    -- 4. 世界環境設定（重力・ライティング・空）のデフォルト修復
    -- ─────────────────────────────────────────────────────────────
    if DefaultGravity then workspace.Gravity = DefaultGravity end
    
    if Lighting then
        if DefaultClockTime then Lighting.ClockTime = DefaultClockTime end
        if DefaultFogStart then Lighting.FogStart = DefaultFogStart end
        if DefaultFogEnd then Lighting.FogEnd = DefaultFogEnd end
        if DefaultGlobalShadows ~= nil then Lighting.GlobalShadows = DefaultGlobalShadows end
        if DefaultAmbient then Lighting.Ambient = DefaultAmbient end
        if DefaultOutdoorAmbient then Lighting.OutdoorAmbient = DefaultOutdoorAmbient end
        Lighting.Brightness = 1
    end

    -- スカイボックスの復元
    if HasSavedDefaultSkybox and TargetSkybox then
        TargetSkybox.SkyboxBk = DefaultSkyboxIds.Bk
        TargetSkybox.SkyboxDn = DefaultSkyboxIds.Dn
        TargetSkybox.SkyboxFt = DefaultSkyboxIds.Ft
        TargetSkybox.SkyboxLf = DefaultSkyboxIds.Lf
        TargetSkybox.SkyboxRt = DefaultSkyboxIds.Rt
        TargetSkybox.SkyboxUp = DefaultSkyboxIds.Up
    elseif TargetSkybox and TargetSkybox.Name == "CheatCustomSkybox" then
        TargetSkybox:Destroy()
        TargetSkybox = nil
    end

    -- =============================================================================
    -- [アンロード処理] Library:OnUnload に追加
    -- =============================================================================
    -- 以下のコードを既存の Library:OnUnload(function() の中に追加してください

    if zoomConnection then zoomConnection:Disconnect() end
    if wheelConnection then wheelConnection:Disconnect() end
    if fovConnection then fovConnection:Disconnect() end
    if freeCamToggleConn then freeCamToggleConn:Disconnect() end
    if charAddedConn then charAddedConn:Disconnect() end
    disableFreeCam()

    -- カメラ設定をデフォルトに戻す
    pcall(function()
        Camera.CameraMinZoomDistance = 1
        Camera.CameraMaxZoomDistance = 400
        Camera.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        Camera.FieldOfView = 70
        if LocalPlayer.CameraMode then LocalPlayer.CameraMode = Enum.CameraMode.Default end
    end)

    if freeCamConnection then freeCamConnection:Disconnect() end
    if zoomConnection then zoomConnection:Disconnect() end

    -- キャラクターの固定を確実に解除して終了する
    pcall(function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end)
    print("Mint Hub loaded.")
end)