"use strict";

function OnUpdateHeroSelection(){
	for ( var teamId of Game.GetAllTeamIDs() )
	{   
            UpdateTeam( teamId );
	}
}

function OnUpdateScore(data){
    // $.Msg(data)
	var teamPanelName = "team_" + data.team_id;
	var teamPanel = $( "#"+teamPanelName );
    var teamScore = teamPanel.FindChildInLayoutFile( "TeamScore" );
    teamScore.text = data.team_kills;
}

function UpdateTeam(teamId)
{
	var teamPanelName = "team_" + teamId;
	var teamPanel = $( "#"+teamPanelName );
	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId );
	teamPanel.SetHasClass( "no_players", ( teamPlayers.length == 0 ) );
	for ( var playerId of teamPlayers )
	{
		UpdatePlayer( teamPanel, playerId);
	}
}

function UpdatePlayer( teamPanel, playerId )
{
	var playerContainer = teamPanel.FindChildInLayoutFile( "PlayerPortraitOverlay" );
	var playerPanelName = "player_" + playerId;
	var playerPanel = playerContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playerContainer, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/custom_top_bar_overlay_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );
	}
	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	var playerPortrait = playerPanel.FindChildInLayoutFile( "PlayerPortrait" );
	if ( playerId == localPlayerInfo.player_id )
	{
		playerPanel.AddClass( "is_local_player" );
	}

	if ( playerInfo.player_selected_hero !== "" )
	{
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		playerPanel.SetHasClass( "hero_selected", true );
		playerPanel.SetHasClass( "hero_highlighted", false );
	}
	else if ( playerInfo.possible_hero_selection !== "" && ( playerInfo.player_team_id == localPlayerTeamId ) )
	{
		playerPortrait.SetImage( "file://{images}/heroes/npc_dota_hero_" + playerInfo.possible_hero_selection + ".png" );
		playerPanel.SetHasClass( "hero_selected", false );
		playerPanel.SetHasClass( "hero_highlighted", true );
	}
	else
	{
		playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
	}

    var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
	playerName.text = playerInfo.player_name;
	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
}

(function(){
	var localPlayerTeamId = -1;
	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( localPlayerInfo != null ){
		localPlayerTeamId = localPlayerInfo.player_team_id;
	}
	var first = true;
	var teamsLeftContainer = $("#HeroSelectTeamsLeftContainer");
	var teamsRightContainer = $("#HeroSelectTeamsRightContainer");
    var teamsContainer;

    var isLeft = true

	for ( var teamId of Game.GetAllTeamIDs() ){       

        if (isLeft){
            teamsContainer = teamsLeftContainer
        }
        else{
            teamsContainer = teamsRightContainer
        }
        isLeft = !isLeft

		var teamPanelName = "team_" + teamId;
		var teamPanel = $.CreatePanel( "Panel", teamsContainer, teamPanelName );
		teamPanel.BLoadLayout( "file://{resources}/layout/custom_game/custom_top_bar_overlay_team.xml", false, false );

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml ){
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			teamLogoPanel.SetAttributeInt( "team_id", teamId );
			teamLogoPanel.BLoadLayout( logo_xml, false, false );
		}
		
		var teamGradient = teamPanel.FindChildInLayoutFile( "TeamGradient" );
		if ( teamGradient && GameUI.CustomUIConfig().team_colors ){
			var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
			teamColor = teamColor.replace( ";", "" );
			teamGradient.style.backgroundColor = teamColor;
		}

		var teamScore = teamPanel.FindChildInLayoutFile( "TeamScore" );   
        teamScore.text = '0';

		teamPanel.AddClass( "TeamPanel" );

		if ( teamId === localPlayerTeamId ){
			teamPanel.AddClass( "local_player_team" );
		}
		else{
			teamPanel.AddClass( "not_local_player_team" );
		} 
	}

	OnUpdateHeroSelection();
	GameEvents.Subscribe( "update_hero_selection", OnUpdateHeroSelection );
	GameEvents.Subscribe( "update_score", OnUpdateScore );
})();

