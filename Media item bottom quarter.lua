-- @description Media Item Smart Tool Vertical Zones - Bottom Quarter Instead of Bottom Half
-- @version 1.0
-- @date 06.19.25
-- @author seemikedrum with credit to Brendan Baker for portions of the code I used from ReaTooled (https://brendanpatrickbaker.com/reatooled)
-- @about
-- This script gives similar functionality to ProTools' "Smart Tool."
-- However, instead of splitting the media item into top and bottom halves, it splits the media item into a top 75% and a bottom 25% portions.
-- It then automatically switches to the razor select tool on the top 75%, or the move tool on the bottom 25% based on the mouse verticle position over the media item.

function GetTopBottomItemQuarter()
local itempart
local x, y = reaper.GetMousePosition()

local item_under_mouse = reaper.GetItemFromPoint(x,y,true)

if item_under_mouse then

  local item_h = reaper.GetMediaItemInfo_Value( item_under_mouse, "I_LASTH" )
  
  local OScoeff = 1
  if reaper.GetOS():match("^Win") == nil then
    OScoeff = -1
  end
  
  local test_point = math.floor( y + (item_h-1) *OScoeff)
  local test_item, take = reaper.GetItemFromPoint( x, test_point, true )
  
  if item_under_mouse == test_item then
    itempart = "header"
  else
    local test_point = math.floor( y + item_h/4 *OScoeff) -- edit the division amount if you want a different percentage for the bottom zone (i.e. /5 for 20%)
    local test_item, take = reaper.GetItemFromPoint( x, test_point, true )
    
    if item_under_mouse ~= test_item then
      itempart = "bottom"
    else
      itempart = "top"
    end
  end
  
  if itempart == "top" then
    switchSelectTool()
  else
    switchMoveTool()
  end

  return item_under_mouse, itempart
else return nil end

end

  
  
  
  

function main()
  reaper.BR_GetMouseCursorContext()
  local pos = reaper.BR_GetMouseCursorContext_Position()
  
  GetTopBottomItemQuarter()
  reaper.defer(main)
end

function exit()
  local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
  reaper.SetToggleCommandState(sectionID, cmdID, 0)
  reaper.RefreshToolbar2(sectionID, cmdID)
end

local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
reaper.SetToggleCommandState(sectionID, cmdID, 1)
reaper.RefreshToolbar2(sectionID, cmdID)

reaper.atexit(exit)

main()









-- Switch to move tool
function switchMoveTool()

was_set=-1

function UpdateState()
  local MM_CTX_ITEM_default=reaper.GetMouseModifier('MM_CTX_ITEM',0)
  local MM_CTX_ITEMLOWER_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0)
  
  local is_set =
    reaper.GetMouseModifier('MM_CTX_ITEM',0) == '13 m' and -- Move item ignoring time selection
    
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0) == '13 m' -- Move item ignoring time selection

        
  if is_set ~= was_set then
    was_set=is_set
    reaper.set_action_options(3 | (is_set and 4 or 8))
  end
  reaper.RefreshToolbar(0)
  reaper.defer(UpdateState)
end

-- Set Mouse Modifiers for each category

reaper.SetMouseModifier('MM_CTX_ITEM',0,'13 m') -- Move item ignoring time selection

reaper.SetMouseModifier('MM_CTX_ITEMLOWER',0,'13 m') -- Move item ignoring time selection


--UpdateState()

reaper.Main_OnCommand(40569,0) --enable locking
reaper.Main_OnCommand(40595,0) -- set item edges lock
reaper.Main_OnCommand(40598,0) --set item fades lock
reaper.Main_OnCommand(41852,0) --set item stretch markers lock
reaper.Main_OnCommand(41849,0) --set item envelope
reaper.Main_OnCommand(40572,0) --set time selection to UNlock
  --reaper.Main_OnCommand(40571,0) --set time selection to lock  

reaper.Main_OnCommand(42621, 0) -- clear arrange override mode
end








-- Switch to select tool
function switchSelectTool()

was_set=-1

function UpdateState()
  local MM_CTX_ITEM_default=reaper.GetMouseModifier('MM_CTX_ITEM',0)
  local MM_CTX_ITEMLOWER_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0)
  
  local is_set =
  
    reaper.GetMouseModifier('MM_CTX_ITEM',0) == '66 m' and -- Select razor edit area and time
    
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0) == '66 m' -- Select razor edit area and time

        
  if is_set ~= was_set then
    was_set=is_set
    reaper.set_action_options(3 | (is_set and 4 or 8))
  end
  reaper.RefreshToolbar(0)
  reaper.defer(UpdateState)
end

-- Set Mouse Modifiers for each category

reaper.SetMouseModifier('MM_CTX_ITEM',0,'66 m') -- Select razor edit area and time

reaper.SetMouseModifier('MM_CTX_ITEMLOWER',0,'66 m') -- Select razor edit area and time


--UpdateState()

reaper.Main_OnCommand(40569,0) --enable locking
reaper.Main_OnCommand(40595,0) -- set item edges lock
reaper.Main_OnCommand(40598,0) --set item fades lock
reaper.Main_OnCommand(41852,0) --set item stretch markers lock
reaper.Main_OnCommand(41849,0) --set item envelope
reaper.Main_OnCommand(40572,0) --set time selection to UNlock
  --reaper.Main_OnCommand(40571,0) --set time selection to lock

reaper.Main_OnCommand(42621, 0) -- clear arrange override mode
end
