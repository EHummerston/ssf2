-----------------------------------------------------------------------------
-- The runtime file for the SSF2 AI framework. Loads the algorithms that will
-- control the 2 player characters, and then repeatedly polls them for input,
-- applying that input to the emulator.
-- 
-- 2017 Edward Hummerston
-----------------------------------------------------------------------------

require("Bert")
require("sfdraw")

debugUI = true -- console outputs and extra text within emulator space

botOne = Bert.new(1)
botTwo = Bert.new(2)

--bertTwo.playerSlot = 2 -- playerSlot not initialising properly in constructor.

while true do  -- loop once per frame
   
   -- erase input values from previous frame
	botOne:resetPad()
	botTwo:resetPad()
	
   -- this memory value is currently incorrect.
	if memory.read_u8(0x10083) == 0x0 then -- if the game is in a fight state
		-- algorithms resolve their controller states
      botOne:advance()
		botTwo:advance()
	end
	
   -- convert separate player input tables to Bizhawk table
	pads = botOne:getPad()
	botTwoPad = botTwo:getPad()

   -- append first table with the second, formatting is already correct
	for k,v in pairs(botTwoPad) do
		pads[k] = v
	end
   
   -- send to emulator
	joypad.set(pads)

   -- draw names
	sfdraw.drawPad(1)
	sfdraw.drawPad(2)
   
   -- draw controllers
	sfdraw.drawName(1, botOne:getName())
	sfdraw.drawName(2, botTwo:getName())
	
	if(debugUI) then
      -- proximity block boolean
		gui.pixelText(4,0,"atk " .. tostring(memory.read_u8(0x5E9) == 0x1))
		gui.pixelText(148,0,"atk " .. tostring(memory.read_u8(0x829) == 0x1))
		
      
      -- action print
		gui.pixelText(4,8,botOne:getAction())
		gui.pixelText(148,8,botTwo:getAction())
      
      gui.pixelText(122,23,tostring(memory.read_u8(0x5EB))) -- distance
      
      gui.pixelText(16,35,tostring(memory.read_u8(0x530)))  -- p1 health
      gui.pixelText(227,35,tostring(memory.read_u8(0x770))) -- p2 health
      
	end
	
   -- emulator resolves cycle
	emu.frameadvance()
	
end

-- DO NOT REACH HERE
error("Infinite loop broken")