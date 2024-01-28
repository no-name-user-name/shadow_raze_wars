"use strict";

function updateButtons(method, param){
    let panel = $("#" + method + "Mode")
    let buttons = panel.FindChildrenWithClassTraverse("ESCMenuButton")
            
    Object.keys(buttons).forEach( (i) => {
        buttons[i].SetHasClass( "active", false );
        let button = parseInt(buttons[i].GetAttributeString('data', ''))

        if (button === param){
            buttons[i].SetHasClass("active", true);
        }
    }); 
}

function setMode(method, param, to_server=true){
    let playerInfo = Game.GetLocalPlayerInfo()
    let isHost = playerInfo.player_has_host_privileges

    if (isHost) {
        updateButtons(method, param)
        if (to_server){
            GameEvents.SendCustomGameEventToServer( "set" + method, { "player_id" : Game.GetLocalPlayerID(), value : param } );
        }
    }

    if (!to_server){
        updateButtons(method, param) 
    }
}

function updateKills(event){
    setMode('Kills', event.value, false)
}
function updateTimer(event){
    setMode('Timer', event.value, false)
}
function updateHunt(event){
    setMode('Hunt', event.value, false)
}

(function()
{
    GameEvents.Subscribe( "setKills", updateKills );
    GameEvents.Subscribe( "setTimer", updateTimer );
    GameEvents.Subscribe( "setHunt", updateHunt );
})();