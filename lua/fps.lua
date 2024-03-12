MAX_SCNL = 30
MAX_FPS = 60

dropframe = 0
was_drop = false
main_end_scanline = 0
fps = 0

nmi = 0
fami = 0
main = 0
draw = 0
logic = 0

function getScanlineOffset()
  state = emu.getState()
  if state.ppu.scanline >= 240 then
    return state.ppu.scanline - 240
  else
    return state.ppu.scanline + 20
  end
end

function printInfo()
  -- print frame drop
  emu.drawString(0, 0, "DRP:" .. dropframe, 0xFFFFFF, 1)
  -- print current fps
  emu.drawString(0, 8, string.format("FPS:%d", math.floor(fps)), 0xFFFFFF, 1)
  -- print current cpu usage
  cpu_use = math.floor((main_end_scanline/260)*100)
  emu.drawString(0, 16, string.format("CPU:%02d",cpu_use) .. "%", 0xFFFFFF, 1)
  -- print other infos
  emu.drawString(4, 24, string.format("NMI:%03d",math.floor(nmi)), 0xFF0000, 1)
  emu.drawString(4, 32, string.format("MUS:%03d",math.floor(fami)), 0xFFFF00, 1)
  emu.drawString(4, 40, string.format("MAIN:%03d",math.floor(main)), 0x00FF00, 1)
  emu.drawString(4, 48, string.format("DRAW:%03d",math.floor(draw)), 0x00FFFF, 1)
  emu.drawString(4, 56, string.format("MATH:%03d",math.floor(logic)), 0x0000FF, 1)
end

function graph()
  tmp = 0
  emu.drawRectangle(0, 0, 256, math.floor(nmi), 0xC0FF0000, 1)
  tmp = tmp + math.floor(nmi)
  emu.drawRectangle(0, tmp, 256, math.floor(fami), 0xC0FFFF00, 1)
  tmp = tmp + math.floor(fami)
  emu.drawRectangle(0, tmp, 256, math.floor(main), 0xC000FF00, 1)
  tmp = tmp + math.floor(main)
  emu.drawRectangle(0, tmp, 256, math.floor(draw), 0xC000FFFF, 1)
  tmp = tmp + math.floor(draw)
  emu.drawRectangle(0, tmp, 256, math.floor(logic), 0xC00000FF, 1)
  emu.drawLine(0, 20, 256, 20, 0xC0FFFFFF, 1)
end

function atEndFrame()
  graph()
  printInfo()
  
  -- update frame drop
  if was_drop then
    dropframe = dropframe + 1
    -- update current scanline
    main_end_scanline = ((MAX_SCNL * main_end_scanline) + 480) / (MAX_SCNL + 1)
  end
  was_drop = true
  -- update fps
  fps = ((MAX_FPS * fps) - 1) / (MAX_FPS + 1)
end

function atEndMain()
  -- validate current frame
  was_drop = false
  -- average current scanline
  s = getScanlineOffset()
  main_end_scanline = ((MAX_SCNL * main_end_scanline) + s) / (MAX_SCNL + 1)
  logic = ((MAX_SCNL * logic) + s - draw) / (MAX_SCNL + 1)
  -- update fps
  fps = ((MAX_FPS * fps) + 120) / (MAX_FPS + 1)
end

function atFamiStart()
  s = getScanlineOffset()
  nmi = ((MAX_SCNL * nmi) + s) / (MAX_SCNL + 1)
end

function atFamiEnd()
  s = getScanlineOffset() - nmi
  fami = ((MAX_SCNL * fami) + s) / (MAX_SCNL + 1)
end

function atMainDraw()
  s = getScanlineOffset() - fami
  main = ((MAX_SCNL * main) + s) / (MAX_SCNL + 1)
end

function atMainLogic()
  s = getScanlineOffset() - main
  draw = ((MAX_SCNL * draw) + s) / (MAX_SCNL + 1)
end

emu.addEventCallback(atEndFrame, emu.eventType.endFrame)
emu.addMemoryCallback(atEndMain,emu.memCallbackType.cpuExec, emu.getLabelAddress("MAIN_end"))
emu.addMemoryCallback(atFamiStart,emu.memCallbackType.cpuExec, emu.getLabelAddress("@DEBUG_FAMISTUDIO_UPDATE_START"))
emu.addMemoryCallback(atFamiEnd,emu.memCallbackType.cpuExec, emu.getLabelAddress("@DEBUG_FAMISTUDIO_UPDATE_END"))
emu.addMemoryCallback(atMainDraw,emu.memCallbackType.cpuExec, emu.getLabelAddress("@DEBUG_MAIN_DRAW"))
emu.addMemoryCallback(atMainLogic,emu.memCallbackType.cpuExec, emu.getLabelAddress("@DEBUG_MAIN_LOGIC"))

emu.displayMessage("Script", "FPS counter")
