-- @description Media Item multitool bottom quarter
-- @version 1.0
-- @date 06.19.25
-- @author seemikedrum with credit to Brendan Baker for portions of the code I took from Retooled (https://brendanpatrickbaker.com/reatooled)
-- @about
--   # This script gives similar functionality to ProTools' "Smart Tool."
-- However, instead of splitting the media item into top and bottom halves, it splits the media item into a top 75% and a bottom 25% portions.
-- It then automatically switches to the razor select tool on the top 75%, or the move tool on the bottom 25%.

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
    local test_point = math.floor( y + item_h/4 *OScoeff)
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
local CMD_ID_1 = reaper.NamedCommandLookup("_RS21aa0b14cf72a27be535d32efe0d05513523aec9")
local CMD_ID_2 = reaper.NamedCommandLookup("_RSd77ea649952c67db183a19cece290cf3e1b3d49d")
local CMD_ID_3 = reaper.NamedCommandLookup("_RSb08c9a159d1a7537eda8df72b777b1cc4c9422e8")
local CMD_ID_4 = reaper.NamedCommandLookup("_RSc2c7d733888679038b4a4341074dc703d0f7f9c2")
local CMD_ID_7 = reaper.NamedCommandLookup("_RS5e85a066efd01fde2482832bf4a3502dce0427b6")

was_set=-1

function UpdateState()
  local MM_CTX_ITEM_default=reaper.GetMouseModifier('MM_CTX_ITEM',0)
  local MM_CTX_ITEMLOWER_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0)
  local MM_CTX_ITEMEDGE_default=reaper.GetMouseModifier('MM_CTX_ITEMEDGE',0)
  local MM_CTX_TRACK_default=reaper.GetMouseModifier('MM_CTX_TRACK',0)
  local MM_CTX_ITEM_CLK_default=reaper.GetMouseModifier('MM_CTX_ITEM_CLK',0)
  local MM_CTX_TRACK_CLK_default=reaper.GetMouseModifier('MM_CTX_TRACK_CLK',0)
  local MM_CTX_ITEMLOWER_CLK_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',0)
  local MM_CTX_ITEM_DBLCLK_default=reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',0)
  local MM_CTX_ITEMLOWER_DBLCLK_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0)  

  
  local is_set =
    reaper.GetMouseModifier('MM_CTX_ITEM',0) == '13 m' and -- Move item ignoring time selection
    reaper.GetMouseModifier('MM_CTX_ITEM',1) == '58 m' and -- Move item contents
    reaper.GetMouseModifier('MM_CTX_ITEM',2) == '51 m' and -- Move item ignoring time selection, enabling ripple edit for all tracks
    reaper.GetMouseModifier('MM_CTX_ITEM',3) == '50 m' and -- Move item ignoring time selection, enabling ripple edit for this track
    reaper.GetMouseModifier('MM_CTX_ITEM',4) == '2 m' and -- Copy item
    reaper.GetMouseModifier('MM_CTX_ITEM',5) == '56 m' and -- Move item contents ignoring snap, ripple earlier adjacent items
    reaper.GetMouseModifier('MM_CTX_ITEM',6) == '7 m' and -- Render item to new file
    reaper.GetMouseModifier('MM_CTX_ITEM',7) == '39 m' and -- Copy item, pooling MIDI source data
    reaper.GetMouseModifier('MM_CTX_ITEM',8) == '32 m' and -- Move item vertically
    reaper.GetMouseModifier('MM_CTX_ITEM',9) == '57 m' and -- Move item contents and right edge ignoring snap, ripple later adjacent items
    reaper.GetMouseModifier('MM_CTX_ITEM',12) == '36 m' and -- Copy item vertically
    reaper.GetMouseModifier('MM_CTX_ITEM',13) == '55 m' and -- Move item contents ignoring snap, ripple all adjacent items
    
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0) == '13 m' and -- Move item ignoring time selection
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',1) == '58 m' and -- Move item contents
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',2) == '51 m' and -- Move item ignoring time selection, enabling ripple edit for all tracks
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',3) == '50 m' and -- Move item ignoring time selection, enabling ripple edit for this track
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',4) == '2 m' and -- Copy item
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',5) == '56 m' and -- Move item contents ignoring snap, ripple earlier adjacent items
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',6) == '7 m' and -- Render item to new file
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',7) == '39 m' and -- Copy item, pooling MIDI source data
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',8) == '32 m' and -- Move item vertically
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',9) == '57 m' and -- Move item contents and right edge ignoring snap, ripple later adjacent items
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',12) == '36 m' and -- Copy item vertically
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',13) == '55 m' and -- Move item contents ignoring snap, ripple all adjacent items

    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',0) == '0' and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',1) == '0' and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',2) == '0' and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',3) == '0' and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',4) == '10 m' and -- Stretch item (relative edge edit)
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',5) == '12 m' and -- Stretch item ignoring snap (relative edge edit)
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',6) == '6 m' and -- Stretch item ignoring selection/grouping
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',7) == '8 m' and -- Stretch item ignoring snap and selection/grouping
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',8) == MM_CTX_ITEMEDGE_default and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',9) == MM_CTX_ITEMEDGE_default and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',10) == MM_CTX_ITEMEDGE_default and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',11) == MM_CTX_ITEMEDGE_default and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',12) == '6 m' and -- Stretch item ignoring selection/grouping
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',13) == MM_CTX_ITEMEDGE_default and
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',14) == '19 m' and -- Adjust loop section start/end
    reaper.GetMouseModifier('MM_CTX_ITEMEDGE',15) == MM_CTX_ITEMEDGE_default and
    
    reaper.GetMouseModifier('MM_CTX_TRACK',0) == '9 m' and -- Marquee select items
    reaper.GetMouseModifier('MM_CTX_TRACK',1) == '13 m' and -- Marquee add to item selection
    reaper.GetMouseModifier('MM_CTX_TRACK',2) == '16 m' and -- Draw a copy of the selected media item, pooling MIDI source data
    reaper.GetMouseModifier('MM_CTX_TRACK',3) == '2 m' and -- Draw a copy of the selected media item ignoring snap
    reaper.GetMouseModifier('MM_CTX_TRACK',4) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',5) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',6) == '16 m' and -- Draw a copy of the selected media item, pooling MIDI source data
    reaper.GetMouseModifier('MM_CTX_TRACK',7) == '17 m' and -- Draw a copy of the selected media item ignoring snap, pooling MIDI source data
    reaper.GetMouseModifier('MM_CTX_TRACK',8) == '14 m' and -- Move time selection
    reaper.GetMouseModifier('MM_CTX_TRACK',9) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',10) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',11) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',12) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',13) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',14) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',15) == MM_CTX_TRACK_default and
    
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',0) == '1 m' and -- Deselect all items and move edit cursor
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',1) == '5 m' and -- Extend time selection
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',2) == '2 m' and -- Deselect all items and move edit cursor ignoring snap
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',3) == '6 m' and -- Extend time selection ignoring snap
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',4) == '8 m' and -- Restore previous zoom level
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',5) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',6) == '4 m' and -- Clear time selection
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',7) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',8) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',9) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',10) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',11) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',12) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',13) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',14) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',15) == MM_CTX_TRACK_CLK_default and

    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',0) == '_RS428db9286d6f978287e14df7cf9227628394585d' and -- Script: ReaTooled_Move Tool Left Click
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',1) == '17 m' and -- Add items to selection and set time selection to selected items
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',2) == '4 m' and -- Toggle item selection
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',4) == '15 m' and -- Add stretch marker
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',8) == '42391 c' and -- Item: Quick add take marker at mouse position
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',9) == '18 m' and -- Add/edit take marker
    
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',0) == '_1eb32b1b95474949883ca579137d130f' and -- Custom: ReaTooled Move Tool Left Click
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',1) == '17 m' and -- Add items to selection and set time selection to selected items
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',2) == '4 m' and -- Toggle item selection
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',4) == '15 m' and -- Add stretch marker
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',8) == '42391 c' and -- Item: Quick add take marker at mouse position
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',9) == '18 m' and -- Add/edit take marker
    
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',0) == '6 m' and -- MIDI: open in editor, Subprojects: open project, Audio: show media item properties

    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0) == '6 m' -- MIDI: open in editor, Subprojects: open project, Audio: show media item properties

        
  if is_set ~= was_set then
    was_set=is_set
    reaper.set_action_options(3 | (is_set and 4 or 8))
  end
  reaper.RefreshToolbar(0)
  reaper.defer(UpdateState)
end

-- Set Mouse Modifiers for each category

reaper.SetMouseModifier('MM_CTX_ITEM',0,'13 m') -- Move item ignoring time selection
reaper.SetMouseModifier('MM_CTX_ITEM',1,'58 m') -- Move item contents
reaper.SetMouseModifier('MM_CTX_ITEM',2,'51 m') -- Move item ignoring time selection, enabling ripple edit for all tracks
reaper.SetMouseModifier('MM_CTX_ITEM',3,'50 m') -- Move item ignoring time selection, enabling ripple edit for this track
reaper.SetMouseModifier('MM_CTX_ITEM',4,'2 m') -- Copy item
reaper.SetMouseModifier('MM_CTX_ITEM',5,'56 m') -- Move item contents ignoring snap, ripple earlier adjacent items
reaper.SetMouseModifier('MM_CTX_ITEM',6,'7 m') -- Render item to new file
reaper.SetMouseModifier('MM_CTX_ITEM',7,'39 m') -- Copy item, pooling MIDI source data
reaper.SetMouseModifier('MM_CTX_ITEM',8,'32 m') -- Move item vertically
reaper.SetMouseModifier('MM_CTX_ITEM',9,'57 m') -- Move item contents and right edge ignoring snap, ripple later adjacent items
reaper.SetMouseModifier('MM_CTX_ITEM',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',12,'36 m') -- Copy item vertically
reaper.SetMouseModifier('MM_CTX_ITEM',13,'55 m') -- Move item contents ignoring snap, ripple all adjacent items
reaper.SetMouseModifier('MM_CTX_ITEM',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEMLOWER',0,'13 m') -- Move item ignoring time selection
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',1,'58 m') -- Move item contents
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',2,'51 m') -- Move item ignoring time selection, enabling ripple edit for all tracks
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',3,'50 m') -- Move item ignoring time selection, enabling ripple edit for this track
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',4,'2 m') -- Copy item
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',5,'56 m') -- Move item contents ignoring snap, ripple earlier adjacent items
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',6,'7 m') -- Render item to new file
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',7,'39 m') -- Copy item, pooling MIDI source data
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',8,'32 m') -- Move item vertically
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',9,'57 m') -- Move item contents and right edge ignoring snap, ripple later adjacent items
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',12,'36 m') -- Copy item vertically
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',13,'55 m') -- Move item contents ignoring snap, ripple all adjacent items
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEMEDGE',0,'0')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',1,'0')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',2,'0')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',3,'0')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',4,'10 m') -- Stretch item (relative edge edit)
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',5,'12 m') -- Stretch item ignoring snap (relative edge edit)
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',6,'6 m') -- Stretch item ignoring selection/grouping
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',7,'8 m') -- Stretch item ignoring snap and selection/grouping
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',9,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',12,'6 m') -- Stretch item ignoring selection/grouping
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',14,'19 m') -- Adjust loop section start/end
reaper.SetMouseModifier('MM_CTX_ITEMEDGE',15,'-1')

reaper.SetMouseModifier('MM_CTX_TRACK',0,'9 m') -- Marquee select items
reaper.SetMouseModifier('MM_CTX_TRACK',1,'13 m') -- Marquee add to item selection
reaper.SetMouseModifier('MM_CTX_TRACK',2,'16 m') -- Draw a copy of the selected media item, pooling MIDI source data
reaper.SetMouseModifier('MM_CTX_TRACK',3,'2 m') -- Draw a copy of the selected media item ignoring snap
reaper.SetMouseModifier('MM_CTX_TRACK',4,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',5,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',6,'16 m') -- Draw a copy of the selected media item, pooling MIDI source data
reaper.SetMouseModifier('MM_CTX_TRACK',7,'17 m') -- Draw a copy of the selected media item ignoring snap, pooling MIDI source data
reaper.SetMouseModifier('MM_CTX_TRACK',8,'14 m') -- Move time selection
reaper.SetMouseModifier('MM_CTX_TRACK',9,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',10,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',11,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',12,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',13,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',14,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',15,'-1')

reaper.SetMouseModifier('MM_CTX_TRACK_CLK',0,'1 m') -- Deselect all items and move edit cursor
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',1,'5 m') -- Extend time selection
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',2,'2 m') -- Deselect all items and move edit cursor ignoring snap
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',3,'6 m') -- Extend time selection ignoring snap
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',4,'8 m') -- Restore previous zoom level
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',6,'4 m') -- Clear time selection
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',9,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',15,'-1')


reaper.SetMouseModifier('MM_CTX_ITEM_CLK',0,'_1eb32b1b95474949883ca579137d130f') -- Custom: ReaTooled Move Tool Left Click
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',1,'17 m') -- Add items to selection and set time selection to selected items
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',2,'4 m') -- Toggle item selection
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',4,'15 m') -- Add stretch marker
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',8,'42391 c') -- Item: Quick add take marker at mouse position
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',9,'18 m') -- Add/edit take marker
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',15,'-1')


reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',0,'_RS428db9286d6f978287e14df7cf9227628394585d') -- Script: ReaTooled_Move Tool Left Click
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',1,'17 m') -- Add items to selection and set time selection to selected items
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',2,'4 m') -- Toggle item selection
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',4,'15 m') -- Add stretch marker
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',8,'42391 c') -- Item: Quick add take marker at mouse position
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',9,'18 m') -- Add/edit take marker
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',0,'6 m') -- MIDI: open in editor, Subprojects: open project, Audio: show media item properties
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',1,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',2,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',4,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',9,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0,'6 m') -- MIDI: open in editor, Subprojects: open project, Audio: show media item properties
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',1,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',2,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',4,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',9,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',15,'-1')

--UpdateState()

reaper.Main_OnCommand(40569,0) --enable locking
reaper.Main_OnCommand(40595,0) -- set item edges lock
reaper.Main_OnCommand(40598,0) --set item fades lock
reaper.Main_OnCommand(41852,0) --set item stretch markers lock
reaper.Main_OnCommand(41849,0) --set item envelope
reaper.Main_OnCommand(40572,0) --set time selection to UNlock
  --reaper.Main_OnCommand(40571,0) --set time selection to lock  

reaper.Main_OnCommand(42621, 0) -- clear arrange override mode

-- Set toolbar button states for additional scripts/buttons
reaper.SetToggleCommandState(0, CMD_ID_1, 0) -- Turn off button 1
reaper.SetToggleCommandState(0, CMD_ID_2, 0) -- Turn off button 2
reaper.SetToggleCommandState(0, CMD_ID_3, 0) -- Turn off button 3
reaper.SetToggleCommandState(0, CMD_ID_4, 1) -- Turn off button 4
reaper.SetToggleCommandState(0, CMD_ID_7, 0) -- Turn off button 7
reaper.SetToggleCommandState(0, reaper.NamedCommandLookup("_RS27973b4ea6ddfabb982b8206b117b31843c68991"), 0) -- scrub tool
reaper.SetToggleCommandState(0, reaper.NamedCommandLookup("_RSb90cf42a9ad3d180fdab1c2fbe82e70a76347b1f"), 0) -- TCE tool
reaper.RefreshToolbar(0)
end








-- Switch to select tool
function switchSelectTool()
-- @description ReaTooled - Razor Select Tool (Selector Tool)
-- @version 1.1
-- @date 2024.02.12
-- @author Brendan Baker
-- @link https://brendanpatrickbaker.com/reatooled/
-- @about
--   # This script loads a set of mouse modifiers focusing on creating razor edit selection, which gives similar functionality to ProTools' "Selector Tool." 
-- CHANGELOG
-- # v1.1 Multiple tweaks to mouse modifier to more closely align with PT behavior

local CMD_ID_1 = reaper.NamedCommandLookup("_RS21aa0b14cf72a27be535d32efe0d05513523aec9")
local CMD_ID_2 = reaper.NamedCommandLookup("_RSd77ea649952c67db183a19cece290cf3e1b3d49d")
local CMD_ID_3 = reaper.NamedCommandLookup("_RSb08c9a159d1a7537eda8df72b777b1cc4c9422e8")
local CMD_ID_4 = reaper.NamedCommandLookup("_RSc2c7d733888679038b4a4341074dc703d0f7f9c2")
local CMD_ID_7 = reaper.NamedCommandLookup("_RS5e85a066efd01fde2482832bf4a3502dce0427b6")

was_set=-1

function UpdateState()
  local MM_CTX_ITEM_default=reaper.GetMouseModifier('MM_CTX_ITEM',0)
  local MM_CTX_ITEMLOWER_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0)
  local MM_CTX_ITEMEDGE_default=reaper.GetMouseModifier('MM_CTX_ITEMEDGE',0)
  local MM_CTX_TRACK_default=reaper.GetMouseModifier('MM_CTX_TRACK',0)
  local MM_CTX_ITEM_CLK_default=reaper.GetMouseModifier('MM_CTX_ITEM_CLK',0)
  local MM_CTX_TRACK_CLK_default=reaper.GetMouseModifier('MM_CTX_TRACK_CLK',0)
  local MM_CTX_ITEMLOWER_CLK_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',0)
  local MM_CTX_ITEM_DBLCLK_default=reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',0)
  local MM_CTX_ITEMLOWER_DBLCLK_default=reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0)  
  
  local is_set =
  
    reaper.GetMouseModifier('MM_CTX_ITEM',0) == '66 m' and -- Select razor edit area and time
    reaper.GetMouseModifier('MM_CTX_ITEM',1) == '28 m' and -- Marquee select items and time
    reaper.GetMouseModifier('MM_CTX_ITEM',2) == '64 m' and -- Add to razor edit area
    reaper.GetMouseModifier('MM_CTX_ITEM',4) == '11 m' and -- Adjust take pitch (semitones)
    reaper.GetMouseModifier('MM_CTX_ITEM',5) == '12 m' and -- Adjust take pitch (fine)
    reaper.GetMouseModifier('MM_CTX_ITEM',9) == '20 m' and -- Adjust item volume
    reaper.GetMouseModifier('MM_CTX_ITEM',13) == '11 m' and -- Adjust take pitch (semitones)
    
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',0) == '66 m' and -- Select razor edit area and time
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',1) == '28 m' and -- Marquee select items and time
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',2) == '64 m' and -- Add to razor edit area
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',4) == '11 m' and -- Adjust take pitch (semitones)
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',5) == '12 m' and -- Adjust take pitch (fine)
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',9) == '20 m' and -- Adjust item volume
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER',13) == '11 m' and -- Adjust take pitch (semitones)
    
    reaper.GetMouseModifier('MM_CTX_TRACK',0) == '29 m' and -- Select razor edit area and time
    reaper.GetMouseModifier('MM_CTX_TRACK',1) == '10 m' and -- Marquee select items and time
    reaper.GetMouseModifier('MM_CTX_TRACK',2) == '27 m' and -- Add to razor edit area
    reaper.GetMouseModifier('MM_CTX_TRACK',3) == '0' and
    reaper.GetMouseModifier('MM_CTX_TRACK',4) == '20 m' and -- Edit loop points
    reaper.GetMouseModifier('MM_CTX_TRACK',5) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',6) == '0' and
    reaper.GetMouseModifier('MM_CTX_TRACK',7) == '0' and
    reaper.GetMouseModifier('MM_CTX_TRACK',8) == '14 m' and -- Move time selection
    reaper.GetMouseModifier('MM_CTX_TRACK',9) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',10) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',11) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',12) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',13) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',14) == MM_CTX_TRACK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK',15) == MM_CTX_TRACK_default and
    
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',0) == '1 m' and -- Deselect all items and move edit cursor
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',1) == '5 m' and -- Extend time selection
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',2) == '2 m' and -- Deselect all items and move edit cursor ignoring snap
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',3) == '6 m' and -- Extend time selection ignoring snap
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',4) == '8 m' and -- Restore previous zoom level
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',5) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',6) == '4 m' and -- Clear time selection
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',7) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',8) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',9) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',10) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',11) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',12) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',13) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',14) == MM_CTX_TRACK_CLK_default and
    reaper.GetMouseModifier('MM_CTX_TRACK_CLK',15) == MM_CTX_TRACK_CLK_default and
    
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',0) == '1 m' and -- Select item and move edit cursor
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',1) == '10 m' and -- Add items to selection and extend time selection
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',2) == '4 m' and -- Toggle item selection
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',4) == '15 m' and -- Add stretch marker
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',8) == '42391 c' and -- Item: Quick add take marker at mouse position
    reaper.GetMouseModifier('MM_CTX_ITEM_CLK',9) == '18 m' and -- Add/edit take marker

    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',0) == '1 m' and -- Select item and move edit cursor
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',1) == '10 m' and -- Add items to selection and extend time selection
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',2) == '4 m' and -- Toggle item selection
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',4) == '15 m' and -- Add stretch marker
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',8) == '42391 c' and -- Item: Quick add take marker at mouse position
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK',9) == '18 m' and -- Add/edit take marker
    
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',0) == '2 m' and -- Set time selection to item
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',1) == '40290 c' and -- Time selection: Set time selection to items
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',2) == '42577 c' and -- Item: Split item under mouse cursor (select right)
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',5) == '40653 c' and -- Item properties: Reset item pitch
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',6) == '7 m' and -- Show take list
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',9) == '_6ca6a69cb0a3488f8bc4ceee437307b7' and -- Custom: Reset Item/Take Volume to 0.00db and Clear Take Envelopes
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',13) == '_468b46ab8e3d4145b3af6c337ef2ac96' and -- Custom: Reset Take and Item Pitch
    reaper.GetMouseModifier('MM_CTX_ITEM_DBLCLK',15) == '_047b1ae44c6a4c398916caefec363247' and -- Custom: Reset Take, Item and Playrate

    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0) == '2 m' and -- Set time selection to item
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',1) == '40290 c' and -- Time selection: Set time selection to items
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',2) == '42577 c' and -- Item: Split item under mouse cursor (select right)
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',5) == '40653 c' and -- Item properties: Reset item pitch
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',6) == '7 m' and -- Show take list
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',9) == '_6ca6a69cb0a3488f8bc4ceee437307b7' and -- Custom: Reset Item/Take Volume to 0.00db and Clear Take Envelopes
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',13) == '_468b46ab8e3d4145b3af6c337ef2ac96' and -- Custom: Reset Take and Item Pitch
    reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',15) == '_047b1ae44c6a4c398916caefec363247'  -- Custom: Reset Take, Item and Playrate

        
  if is_set ~= was_set then
    was_set=is_set
    reaper.set_action_options(3 | (is_set and 4 or 8))
  end
  reaper.RefreshToolbar(0)
  reaper.defer(UpdateState)
end

-- Set Mouse Modifiers for each category

reaper.SetMouseModifier('MM_CTX_ITEM',0,'66 m') -- Select razor edit area and time
reaper.SetMouseModifier('MM_CTX_ITEM',1,'28 m') -- Marquee select items and time
reaper.SetMouseModifier('MM_CTX_ITEM',2,'64 m') -- Add to razor edit area
reaper.SetMouseModifier('MM_CTX_ITEM',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',4,'11 m') -- Adjust take pitch (semitones)
reaper.SetMouseModifier('MM_CTX_ITEM',5,'12 m') -- Adjust take pitch (fine)
reaper.SetMouseModifier('MM_CTX_ITEM',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',9,'20 m') -- Adjust item volume
reaper.SetMouseModifier('MM_CTX_ITEM',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',13,'11 m') -- Adjust take pitch (semitones)
reaper.SetMouseModifier('MM_CTX_ITEM',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEMLOWER',0,'66 m') -- Select razor edit area and time
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',1,'28 m') -- Marquee select items and time
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',2,'64 m') -- Add to razor edit area
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',4,'11 m') -- Adjust take pitch (semitones)
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',5,'12 m') -- Adjust take pitch (fine)
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',9,'20 m') -- Adjust item volume
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',13,'11 m') -- Adjust take pitch (semitones)
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER',15,'-1')

reaper.SetMouseModifier('MM_CTX_TRACK',0,'29 m') -- Select razor edit area and time
reaper.SetMouseModifier('MM_CTX_TRACK',1,'10 m') -- Marquee select items and time
reaper.SetMouseModifier('MM_CTX_TRACK',2,'27 m') -- Add to razor edit area
reaper.SetMouseModifier('MM_CTX_TRACK',3,'0')
reaper.SetMouseModifier('MM_CTX_TRACK',4,'20 m') -- Edit loop points
reaper.SetMouseModifier('MM_CTX_TRACK',5,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',6,'0')
reaper.SetMouseModifier('MM_CTX_TRACK',7,'0')
reaper.SetMouseModifier('MM_CTX_TRACK',8,'14 m') -- Move time selection
reaper.SetMouseModifier('MM_CTX_TRACK',9,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',10,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',11,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',12,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',13,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',14,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK',15,'-1')

reaper.SetMouseModifier('MM_CTX_TRACK_CLK',0,'1 m') -- Deselect all items and move edit cursor
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',1,'5 m') -- Extend time selection
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',2,'2 m') -- Deselect all items and move edit cursor ignoring snap
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',3,'6 m') -- Extend time selection ignoring snap
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',4,'8 m') -- Restore previous zoom level
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',6,'4 m') -- Clear time selection
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',9,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_TRACK_CLK',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEM_CLK',0,'1 m') -- Select item and move edit cursor
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',1,'10 m') -- Add items to selection and extend time selection
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',2,'4 m') -- Toggle item selection
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',4,'15 m') -- Add stretch marker
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',8,'42391 c') -- Item: Quick add take marker at mouse position
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',9,'18 m') -- Add/edit take marker
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_CLK',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',0,'1 m') -- Select item and move edit cursor
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',1,'10 m') -- Add items to selection and extend time selection
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',2,'4 m') -- Toggle item selection
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',4,'15 m') -- Add stretch marker
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',5,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',6,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',8,'42391 c') -- Item: Quick add take marker at mouse position
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',9,'18 m') -- Add/edit take marker
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',13,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK',15,'-1')

reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',0,'2 m') -- Set time selection to item
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',1,'40290 c') -- Time selection: Set time selection to items
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',2,'42577 c') -- Item: Split item under mouse cursor (select right)
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',4,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',5,'40653 c') -- Item properties: Reset item pitch
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',6,'7 m') -- Show take list
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',9,'_6ca6a69cb0a3488f8bc4ceee437307b7') -- Custom: Reset Item/Take Volume to 0.00db and Clear Take Envelopes
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',13,'_468b46ab8e3d4145b3af6c337ef2ac96') -- Custom: Reset Take and Item Pitch
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEM_DBLCLK',15,'_047b1ae44c6a4c398916caefec363247') -- Custom: Reset Take, Item and Playrate

reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',0,'2 m') -- Set time selection to item
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',1,'40290 c') -- Time selection: Set time selection to items
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',2,'42577 c') -- Item: Split item under mouse cursor (select right)
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',3,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',4,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',5,'40653 c') -- Item properties: Reset item pitch
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',6,'7 m') -- Show take list
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',7,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',8,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',9,'_6ca6a69cb0a3488f8bc4ceee437307b7') -- Custom: Reset Item/Take Volume to 0.00db and Clear Take Envelopes
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',10,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',11,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',12,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',13,'_468b46ab8e3d4145b3af6c337ef2ac96') -- Custom: Reset Take and Item Pitch
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',14,'-1')
reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK',15,'_047b1ae44c6a4c398916caefec363247') -- Custom: Reset Take, Item and Playrate


--UpdateState()

reaper.Main_OnCommand(40569,0) --enable locking
reaper.Main_OnCommand(40595,0) -- set item edges lock
reaper.Main_OnCommand(40598,0) --set item fades lock
reaper.Main_OnCommand(41852,0) --set item stretch markers lock
reaper.Main_OnCommand(41849,0) --set item envelope
reaper.Main_OnCommand(40572,0) --set time selection to UNlock
  --reaper.Main_OnCommand(40571,0) --set time selection to lock

reaper.Main_OnCommand(42621, 0) -- clear arrange override mode

-- Set toolbar button states for additional scripts/buttons
reaper.SetToggleCommandState(0, CMD_ID_1, 0) -- Turn off button 1
reaper.SetToggleCommandState(0, CMD_ID_2, 0) -- Turn off button 2
reaper.SetToggleCommandState(0, CMD_ID_3, 1) -- Turn off button 3
reaper.SetToggleCommandState(0, CMD_ID_4, 0) -- Turn off button 4
reaper.SetToggleCommandState(0, CMD_ID_7, 0) -- Turn off button 7
reaper.SetToggleCommandState(0, reaper.NamedCommandLookup("_RS27973b4ea6ddfabb982b8206b117b31843c68991"), 0) -- scrub tool
reaper.SetToggleCommandState(0, reaper.NamedCommandLookup("_RSb90cf42a9ad3d180fdab1c2fbe82e70a76347b1f"), 0) -- TCE tool
reaper.RefreshToolbar(0)
end
