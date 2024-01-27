"use strict";

function SetKills(k)
{
    let panel = $("#ESCActionButtons")
    let buttons = panel.FindChildrenWithClassTraverse("ESCMenuButton")

    Object.keys(buttons).forEach( (i) => {
        buttons[i].SetHasClass( "active", false );
        let button_kills = parseInt(buttons[i].GetAttributeString('data', ''))

        if (button_kills === k){
            buttons[i].SetHasClass("active", true);
        }
    });

	GameEvents.SendCustomGameEventToServer( "voteKills", { "player_id" : Game.GetLocalPlayerID(), "kills" : k } );
}