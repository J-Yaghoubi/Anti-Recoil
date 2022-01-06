-- Anti-Recoil Script.
-- By seyed jafar yaghoubi

-- [INSTALLING GUIDE]
-- Please Read README.md on the below address before using this script to know how should use it:
-- https://github.com/J-Yaghoubi/Anti-Recoil
   
-- [Attention]
-- This tool is written for educational purposes only, use it at your own risk/responsibility.

-- [LANGUAGE]
-- The script is in LUA language and has been tested on Logitech G604 mouse. 

-- [RESPONSIBILITY]
-- The main target of the script is to decrease weapon recoil on the shooting PC games. You have an extra option 
-- in the script, If you active AUTO-ADS then every time you click the fire button, the weapon will goes to ADS (scope) 
-- automatically and then fire. So you have two things with this tool:
--    1: Recoil Control
--    2: Auto ADS

-- [APPROCH]
-- This script does not use any fixed pattern for Weapons. This approach has two main pros:
--     1: This is a versatile tool that you can use for any weapon. Just adjust the settings and have fun! 
--     2: This is hard for monitoring systems (anti-cheat) to detect tools that have random activity/pattern.
-- Despite this pros, the cons side is that you can not turn recoil to zero. 

-- [RECOIL PATTERN SETTINGS]
-- The setting process is easy. You can define two different patterns for your primary and secondary weapon. 
-- In the pattern, you should set Vertical and Horizontal recoil values and the delay for every action in milliseconds. 
-- You need to adjust these three factors to get minimum possible recoil for your favorite weapon.
-- The Negative value means left in horizontal or up in vertical and vice versa.
-- There is one extra input in the pattern witch is AdsDelay. This is the time that your weapon needs to go on ADS(scope) 
-- and it is usable when you turn on AUTO-ADS mode.


--------------------------------------------- User Settings -------------------------------------------------------

local Activate_Key        = "numlock"     -- Turn-On numlock to active the script
local Auto_ADS_Key        = "capslock"    -- Turn-On capslock to active Auto-ADS when you are firing

local Fire_key            = 1	          -- Your Mouse Left-Click (Fire)
local ADS_key             = 3	          -- Your Mouse Right-Click (ADS)
local Weapon_switch_key   = 9             -- Switch between Weapon-Patterns 

weapon_table = {}
weapon_table["primary"]  = { Horizontal= -0.2, Vertical= 1, FireDelay= 7, AdsDelay= 300} -- Your Primary weapon recoil-pattern
weapon_table["secondary"]= { Horizontal= -0.1, Vertical= 2, FireDelay= 8, AdsDelay= 130} -- Your Secondary weapon recoil-pattern

local current_weapon = "primary"          -- The Recoil-pattern you want to be activated on the start

------------------------------------------ END OF USER SETTINGS ---------------------------------------------------

local VERSION = "0.0.1"
local script_active = true

-- Random Coefficient generator

function Volatility(range, impact)
    local interupt = range * (1 + impact * math.random())
    return interupt
end

-- Move mouse by X

function Move_x(_horizontal_recoil)
    MoveMouseRelative(math.floor(Volatility(0.7, 1) * _horizontal_recoil), 0)  -- 70 ~ 140 %
end    

-- Move mouse by y

function Move_y(_vertical_recoil)
    MoveMouseRelative(0, math.floor(Volatility(0.7, 1) * _vertical_recoil)) -- 70 ~ 140 %
end    

-- Direct Fire 

function Direct_Fire()

    local horizontal_recoil = weapon_table[current_weapon]["Horizontal"]
    local vertical_recoil   = weapon_table[current_weapon]["Vertical"]
    
    local float_x = math.abs(horizontal_recoil) - math.floor(math.abs(horizontal_recoil))
    local float_y = math.abs(vertical_recoil) - math.floor(math.abs(vertical_recoil))

    local i = 0
    local j = 0

    repeat
        
        -- move mouse by integer value of horizontal and vertical recoil

        if horizontal_recoil ~= 0  then
            if horizontal_recoil < 0 then
                Move_x(horizontal_recoil + float_x)
            else  
                Move_x(vertical_recoil - float_x)
            end 
        end 

        if vertical_recoil ~= 0  then
            if vertical_recoil < 0 then
                Move_y(vertical_recoil + float_y)
            else 
                Move_y(vertical_recoil - float_y)
            end 
        end 
     
        -- if the horizontal recoil value is not integer then start the counter
        -- and when it arrived in 1 or greater, move the mouse by 1 pixel

        if float_x ~= 0 then 

            i = i + float_x   -- count until 1
            
            if i >= 1 * Volatility(0.7, 1) then -- compare with randomized number

                -- if value is positive move to right else move to left

                if horizontal_recoil > 0 then -- compare with randomized value
                    Move_x(1) 
                else
                    Move_x(-1)
                end    
                -- reset the counter
                i = 0 
            end   
        end   

        -- if the vertical recoil value is not integer then start the counter
        -- and when it arrived in 1 or greater, move the mouse by 1 pixel

        if float_y ~= 0 then 

            j = j + float_y   -- count until 1
            
            if j >= 1 * Volatility(0.7, 1)  then  -- compare with randomized number

                -- if value is positive move to down else move to up

                if vertical_recoil > 0 then
                    Move_y(1) 
                else
                    Move_y(-1)
                end    
                -- reset the counter
                j = 0 
            end   
        end   

        Sleep(math.floor(Volatility(0.8, 0.5) * weapon_table[current_weapon]["FireDelay"]))   -- 80 ~ 120 %

    until not IsMouseButtonPressed(Fire_key)

end

-- Go to ADS and Fire 

function ADS_Fire()
    PressMouseButton(ADS_key)
    Sleep(weapon_table[current_weapon]["AdsDelay"])
    Direct_Fire()
    ReleaseMouseButton(ADS_key)
    Sleep(40)
end

-- Initialize and show settings

function Initialize()

    ClearLog()
    OutputLogMessage('--> Welcome to Anti-Recoil script\n')
    OutputLogMessage('--> Version: %s\n', VERSION) 
    OutputLogMessage('--> By: Seyed Jafar Yaghoubi\n') 
    OutputLogMessage('\n') 
    OutputLogMessage('Selected weapon: %s\n', current_weapon) 
    OutputLogMessage('Fire button: %s\n', Fire_key)
    OutputLogMessage('ADS button: %s\n', ADS_key) 
    OutputLogMessage('Weapon switch: %s\n', Weapon_switch_key)     
    OutputLogMessage('Auto ADS: %s\n', Auto_ADS_Key)
    OutputLogMessage('\n') 
    
    if IsKeyLockOn(Activate_Key) then
        script_active = true
        OutputLogMessage('Script is On and ready\n')
    else
        script_active = false
        OutputLogMessage('Script is Off...\n')
        OutputLogMessage('You can active it by pressing: %s\n', Activate_Key)
    end

end    

-- Initialize

Initialize()

-- Script loop

function OnEvent(event, arg)

    if (event == "PROFILE_ACTIVATED") then
        EnablePrimaryMouseButtonEvents(true)
    elseif event == "PROFILE_DEACTIVATED" then
        ReleaseMouseButton(Fire_key)
        ReleaseMouseButton(ADS_key)
    end

    -- if the script is active

    if IsKeyLockOn(Activate_Key) then
        
        -- if script toggled from on to off

        if script_active == false then
            script_active = true
            OutputLogMessage('Script is on...\n')
        end    

        -- if user changed the weapon profile

        if (event == "MOUSE_BUTTON_PRESSED" and arg == Weapon_switch_key) then             
            if current_weapon == "primary" then
                current_weapon = "secondary"
                OutputLogMessage('Secondary weapon profile activated...\n')  
            else
                current_weapon = "primary"
                OutputLogMessage('Primary weapon profile activated...\n')  
            end    
        end

        -- if user pressed fire-key

        if (event == "MOUSE_BUTTON_PRESSED" and arg == Fire_key) then        

            if IsKeyLockOn(Auto_ADS_Key) then 
                ADS_Fire()
            else
                Direct_Fire()
            end  

        end  

    else

        -- if script toggled from off to on, print message in console

        if script_active == true then
            script_active = false
            OutputLogMessage('Script is off...\n')
        end 

    end  -- end of main function  

end -- end of loop
