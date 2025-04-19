local DelWH = function(url)
    local request = http_request or request
    request({
        Url = url,
        Method = "DELETE",
        Headers = {["Content-Type"] = "application/json"}
    })
end

local SendMsg = function(url, msg)
    local request = http_request or request
    request({
        Url = url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({
            content = msg,
            username = "Webhook Manager",
		    avatar_url = "https://raw.githubusercontent.com/ScripterTSBG/Webhook-Manager/refs/heads/main/webhook.png"
        })
    })
end

local toggles = {
    Delete = false,
    Send = false,
    Block = false,
    UI = true,
    UIKeybind = "L",
    SendText = ""
}

makefolder("Webhook-Manager")

local essential_files = {
    images = {
        logo = {name = "Webhook-Manager/Logo.png", url = "https://raw.githubusercontent.com/ScripterTSBG/Webhook-Manager/refs/heads/main/webhook.png"}
    },
    ui = {
        main = {name = "Webhook-Manager/MAIN_UI.rbxm", url = "https://github.com/ScripterTSBG/Webhook-Manager/raw/refs/heads/main/UI.rbxm"}
    }
}

local assets = {}

function GitDownload(GIT_URL, ASSET_NAME)
    local fileName = tostring(ASSET_NAME)
    if not isfile(fileName) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Downloading...",
            Text = "Downloading " .. ASSET_NAME .. "...",
            Duration = 3
        })
        local success, result = pcall(function()
            return game:HttpGet(GIT_URL)
        end)
        if success then
            writefile(fileName, result)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Download Complete",
                Text = ASSET_NAME .. " downloaded successfully!",
                Duration = 3
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Download Failed",
                Text = "Failed to download " .. ASSET_NAME .. "\n" .. result,
                Duration = 5
            })
            return nil
        end
    end
    return (getcustomasset or getsynasset)(fileName)
end

for category, files in pairs(essential_files) do
    assets[category] = {}
    for key, file in pairs(files) do
        if file.name and file.url and file.url ~= "" then
            assets[category][key] = GitDownload(file.url,file.name)
        end
    end
end

local Notification_Library = loadstring(request({Url = "https://github.com/ScripterTSBG/Notification-System/raw/refs/heads/main/notification.lua", Method = 'GET'}).Body)()

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local info = TweenInfo.new(0.25)

local MAIN_UI = game:GetObjects(assets.ui.main)[1]
local Container = MAIN_UI:WaitForChild("Container")
local Navbar = Container:WaitForChild("Navbar")
local header = Container:WaitForChild("header")
local Main = Container:WaitForChild("Main")

local Main_Home = Main:WaitForChild("Home")
local Main_Config = Main:WaitForChild("Config")
local Main_Credits = Main:WaitForChild("Credits")

local Navbar_Home = Navbar:WaitForChild("Home")
local Navbar_Config = Navbar:WaitForChild("Config")
local Navbar_Credits = Navbar:WaitForChild("Credit")

local Message_TextBox = Main_Config:WaitForChild("Webhook_TextBox")
local Keybind_TextBox = Main_Config:WaitForChild("Z_Keybind_TextBox")

local Send_Switch = Main_Home:WaitForChild("Z_Switch_Send")
local Block_Switch = Main_Home:WaitForChild("Z_Switch_Block")
local Delete_Switch = Main_Home:WaitForChild("Z_Switch_Delete")

local function toggleSwitch(btn, flag)
	toggles[flag] = not toggles[flag]
	TS:Create(btn.smthRound, info, {
		BackgroundColor3 = toggles[flag] and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0),
		Position = toggles[flag] and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
	}):Play()
end

Send_Switch.Switch_Button.MouseButton1Click:Connect(function()
	toggleSwitch(Send_Switch.Switch_Button, "Send")
end)

Block_Switch.Switch_Button.MouseButton1Click:Connect(function()
	toggleSwitch(Block_Switch.Switch_Button, "Block")
end)

Delete_Switch.Switch_Button.MouseButton1Click:Connect(function()
	toggleSwitch(Delete_Switch.Switch_Button, "Delete")
end)

Navbar_Home.MouseButton1Click:Connect(function()
	Main_Home.Visible = true
	Main_Config.Visible = false
	Main_Credits.Visible = false
end)

Navbar_Config.MouseButton1Click:Connect(function()
	Main_Home.Visible = false
	Main_Config.Visible = true
	Main_Credits.Visible = false
end)

Navbar_Credits.MouseButton1Click:Connect(function()
	Main_Home.Visible = false
	Main_Config.Visible = false
	Main_Credits.Visible = true
end)

MAIN_UI.Parent = CoreGui

RS.RenderStepped:Connect(function()
	MAIN_UI.Enabled = toggles.UI
end)

UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and Enum.KeyCode[toggles.UIKeybind] == input.KeyCode then
		toggles.UI = not toggles.UI
		toggles.UIKeybind = Keybind_TextBox.Text
		toggles.SendText = Message_TextBox.Text
        if Keybind_TextBox.Text == "" then
            toggles.UIKeybind = "L"
        end
	end
end)

local dragging, dragInput, startPos, startInputPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = Container.Position
		startInputPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startInputPos
		Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local oldreq = getgenv().request
getgenv().request = function(req)
    if req and req.Url and req.Url:find("https://discord.com/api/webhooks") then
        Notification_Library.createNotification("Success", "Detected a webhook!", 2)
        if toggles.Send then
            SendMsg(req.Url, toggles.SendText ~= "" and toggles.SendText or "Intercepted by Webhook Manager")
        end
        if toggles.Delete then
            DelWH(req.Url)
        end
        if toggles.Block then
            return
        end
    end
    return oldreq(req)
end

getgenv().httprequest = getgenv().request
getgenv().httpRequest = getgenv().request
getgenv().http_request = getgenv().request
getgenv().http.request = getgenv().request
