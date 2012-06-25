--[[
	Project: Quomen - Quantum/Omen Sight Monitor
	Version: 1.0
	Author: OKeez
]] 
Quomen = Quomen or {}
Quomen.active = Quomen.active or true

local context = UI.CreateContext("Context")
local gaw = 1
local skillName = "Quantum/Omen Sight";
local searchForSkillName = true;
local foundSkillName = false;

MsgFrame = UI.CreateFrame("Frame","MsgFrame", context)
MsgFrame.text = UI.CreateFrame("Text", "Text", MsgFrame)
MsgFrame.texture = UI.CreateFrame("Texture", "Texture", MsgFrame)
MsgFrame.text:SetVisible(false)
MsgFrame.text:SetText("Your " .. skillName .. " has expired")
MsgFrame.text:SetFontSize(20)
MsgFrame.text:SetHeight(MsgFrame.text:GetFullHeight())
MsgFrame.text:SetWidth(MsgFrame.text:GetFullWidth())
MsgFrame.text:SetPoint("CENTER", UIParent, "CENTER")
MsgFrame.text:SetAlpha(80)

print("Quantum/Omen Sight Monitor. \nType /quomen help for options.")

local function on()
	Quomen.active = true
	print(skillName .. " monitoring enabled.")
end

local function off()
	Quomen.active = false
	print(skillName .. " monitoring disabled.")
	MsgFrame.text:SetVisible(false)
	MsgFrame.texture:SetVisible(false)
end

local function help()
	print("Usage: /quomen [option]:")
   print("    on: switch Quomen on")
   print("    off: switch Quomen off")
   print("    switch: switch Quomen on/off state")	
end

local function display()
	MsgFrame.text:SetVisible(true)
	MsgFrame.texture:SetVisible(true)
end

local function clear()
	MsgFrame.text:SetVisible(false)
	MsgFrame.texture:SetVisible(false)
end

local function findSkillName()
       local list = Inspect.Ability.List()
       if not list then return end
 
       local details = Inspect.Ability.Detail(list)
       for id, ability in pairs(details) do
              --print(ability.name)
              if ability.name == "Quantum Sight" or
                 ability.name == "Omen Sight" then
                      skillName = ability.name
                      --print("found "..ability.name)
                      foundSkillName = true;
                      MsgFrame.text:SetText("Your " .. skillName .. " has expired")
              end
       end
       searchForSkillName = false;
end

local function refresh()
        if (searchForSkillName) then
           findSkillName()
        end
	if (Quomen.active == true and foundSkillName) then
	gaw = gaw -1
	if gaw < 0 then
		local blt = Inspect.Buff.List("player")
		if not blt then return end 
		local bds = Inspect.Buff.Detail("player", blt)
		local fmf = 0
		for id, buff in pairs(bds) do
			if id ~=nil then
				if buff.name == "Quantum Sight" then
				fmf = 1 
				end
				if buff.name == "Omen Sight" then
				fmf = 1 
				end
			end	
		end
		if fmf == 0 then display() end
		if fmf == 1 then clear() end
		gaw=1
	end
	end
end

local function process(param)
   --print(param)
   if( (param ~= nil) and (param ~= "")) then
      
      local found = false;
   
      if(param == "help") then 
         help() 
         found = true
      end
      
      if(param == "on") then 
         on() 
         found = true
      end 
      
      if(param == "off") then 
         off() 
         found = true
      end 
      
      if(param == "switch") then 
          Quomen.active = not Quomen.active
          if(Quomen.active) then 
             on() 
          else 
             off() 
          end 
         found = true
      end       
      
      if( not found) then
         print("Unknown option [" .. param .."] type /quomen help for valid options")
      end
           
   else
      help()
   end
end;

table.insert(Event.System.Update.Begin, {refresh, "Quomen", "refresh"})
table.insert(Command.Slash.Register("quomen"), {function (params) process(params) end, "Quomen", "Slash command"})
