local dieWidget;
local effortDie;

function onInit()
    -- Initialize radial menu
    registerMenuItem(Interface.getString("radial_override"), "customdice", 7);
    registerMenuItem(Interface.getString("dice_menu_d4"), "radial_icon_d4", 7, 4);
    registerMenuItem(Interface.getString("dice_menu_d6"), "radial_icon_d6", 7, 5);
    registerMenuItem(Interface.getString("dice_menu_d8"), "radial_icon_d8", 7, 6);
    registerMenuItem(Interface.getString("dice_menu_d10"), "radial_icon_d10", 7, 7);
    registerMenuItem(Interface.getString("dice_menu_d12"), "radial_icon_d12", 7, 8);
    registerMenuItem(Interface.getString("radial_reset"), "imagesizeoriginal", 7, 1);

    -- Add the dice widget
    loadDie();
    setRollableWidget(effortDie);

    addSource("effort." .. target[1] .. ".base");
    addSource("effort." .. target[1] .. ".loot");
    
    super.onInit();
end

function onMenuSelection(subselection, subsubselection)
    if subselection == 7 then
        if subsubselection == 4 then
            setRollableWidget("d4");
            setDie("d4");
        elseif subsubselection == 5 then
            setRollableWidget("d6");
            setDie("d6");
        elseif subsubselection == 6 then
            setRollableWidget("d8");
            setDie("d8");
        elseif subsubselection == 7 then
            setRollableWidget("d10");
            setDie("d10");
        elseif subsubselection == 8 then
            setRollableWidget("d12");
            setDie("d12");
        elseif subsubselection == 1 then
            setRollableWidget();
            setDie();
        end
    end
end

function onSourceUpdate(node)
    local nodeWin = window.getDatabaseNode();
    local nBase = DB.getValue(nodeWin, "effort." .. target[1] .. ".base", 0);
    local nLoot = DB.getValue(nodeWin, "effort." .. target[1] .. ".loot", 0);

    setValue(nBase + nLoot);
end

function action(draginfo)
    local nodeWin = window.getDatabaseNode();
    local rActor = ActorManager.resolveActor(nodeWin);
    local effort = DB.getValue(nodeWin, "effort." .. self.target[1] .. ".die", self.die[1]);

    -- For some reason, if the die node doesn't exist, effort is being set to "" rather than self.die, so we have to test for that here.
    if effort ~= "" then
        ActionEffort.performRoll(draginfo, rActor, self.target[1], effort);
    else
        ActionEffort.performRoll(draginfo, rActor, self.target[1], self.die[1]);
    end
    return true;
end

function onDragStart(button, x, y, draginfo)
    return action(draginfo);
end
    
function onDoubleClick(x,y)
    return action();
end

function setRollableWidget(die)
    if dieWidget then
        dieWidget.destroy();
    end
    
    if die then
        dieWidget = addBitmapWidget("effort_" .. die)
        if dieWidget then
            dieWidget.setPosition("bottomleft", -1, -4);
        end
    else
        dieWidget = addBitmapWidget("field_rollable");
        dieWidget.setPosition("bottomleft", -1, -4);
    end
    setHoverCursor("hand");
end

function setDie(die)
    local nodeWin = window.getDatabaseNode();

    if die then
        effortDie = die;
        DB.setValue(nodeWin, "effort." .. self.target[1] .. ".die", "string", die);
    else
        effortDie = self.die[1];
        DB.setValue(nodeWin, "effort." .. self.target[1] .. ".die", "string", null);
    end
end

function loadDie() 
    local nodeWin = window.getDatabaseNode();
    local d = DB.getValue(nodeWin, "effort." .. self.target[1] .. ".die", "");
    -- Only set the effort die if it has a non-null value
    if d ~= "" then
        effortDie = d;
    end
end