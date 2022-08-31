
SET SERVEROUTPUT ON;

-- Task 1 Part A: INSERT 

CREATE OR REPLACE PROCEDURE spGamesInsert (
    game_ID OUT games.gameID%type,
    div_id games.divID%type,
    game_num games.gameNum%type,
    game_dateTime games.gameDateTime%type,
    home_team games.homeTeam%type,
    home_score games.homeScore%type,
    visit_team games.visitTeam%type,
    visit_score games.visitScore%type,
    location_id games.locationID%type,
    is_played games.isPlayed%type,
    notes_ games.notes%type
    ) AS
BEGIN
    INSERT INTO games
        VALUES(NULL, div_id, game_num, game_dateTime, home_team, home_score, visit_team,
                visit_score, location_id, is_played, notes_)
                RETURNING games.gameID INTO game_ID;
EXCEPTION
    WHEN VALUE_ERROR THEN game_ID := -2;
    WHEN OTHERS THEN game_ID := -1;
END spGamesInsert;

CREATE OR REPLACE PROCEDURE spGoalScorersInsert (
    goal_id OUT goalscorers.goalid%type,
    game_id IN goalscorers.gameid%type,
    player_id IN goalscorers.playerid%type,
    team_id IN goalscorers.teamid%type,
    num_goals IN goalscorers.numgoals%type,
    num_assists IN goalscorers.numassists%type
    ) AS
BEGIN
    INSERT INTO goalscorers
        VALUES (NULL, game_id, player_id, team_id, num_goals, num_assists)
        RETURNING goalscorers.goalid INTO goal_id;
EXCEPTION
    WHEN VALUE_ERROR THEN goal_id := -2;
    WHEN OTHERS THEN goal_id := -1;
END spGoalScorersInsert;

CREATE OR REPLACE PROCEDURE spPlayersInsert (
    player_ID IN OUT players.playerID%type,
    reg_number players.regNumber%type,
    last_name players.lastName%type,
    first_name players.firstName%type,
    is_active players.isActive%type
    ) AS
    CURSOR check_id IS
        SELECT playerID FROM players;
BEGIN
    FOR temp IN check_ID
    LOOP
        IF player_ID = temp.playerID THEN
            player_ID := -3;
        END IF;
    END LOOP;
    IF player_ID != -3 THEN
        INSERT INTO players
            VALUES(player_ID, reg_number, last_name, first_name, is_active)
                RETURNING players.playerID INTO player_ID;
    END IF;
EXCEPTION
    WHEN VALUE_ERROR THEN player_ID := -2;
    WHEN OTHERS THEN player_ID := -1;
END spPlayersInsert;

CREATE OR REPLACE PROCEDURE spTeamsInsert (
    team_id IN OUT teams.teamid%type,
    team_name teams.teamname%type,
    active teams.isactive%type,
    jersey_color teams.jerseycolour%type
    ) AS
    CURSOR check_id IS
        SELECT teamid FROM teams;
BEGIN

    FOR temp IN check_ID
    LOOP
        IF team_id = temp.teamid THEN
            team_id := -3;
        END IF;
    END LOOP;

    IF team_id != -3 THEN
        INSERT INTO teams
            VALUES(team_id, team_name, active, jersey_color)
                RETURNING teams.teamid INTO team_id;
    END IF;
EXCEPTION
    WHEN VALUE_ERROR THEN team_id := -2;
    WHEN OTHERS THEN team_id := -1;
END spTeamsInsert;

CREATE OR REPLACE PROCEDURE spRostersInsert (
    p_ROSTERID in OUT ROSTERS.ROSTERID%type
    ,p_PLAYERID in ROSTERS.PLAYERID%type default null 
    ,p_TEAMID in ROSTERS.TEAMID%type default null 
    ,p_ISACTIVE in ROSTERS.ISACTIVE%type default null 
    ,p_JERSEYNUMBER in ROSTERS.JERSEYNUMBER%type default null 
    )
    AS
BEGIN
    INSERT INTO ROSTERS
        VALUES (
            NULL
            ,p_PLAYERID
            ,p_TEAMID
            ,p_ISACTIVE
            ,p_JERSEYNUMBER
            )
            RETURNING rosters.rosterid INTO p_ROSTERID;
EXCEPTION
    WHEN VALUE_ERROR THEN p_ROSTERID := -2;
    WHEN OTHERS THEN p_ROSTERID := -1;
END spRostersInsert;

CREATE OR REPLACE PROCEDURE spslLocationsInsert (
    p_LOCATIONID in OUT SLLOCATIONS.LOCATIONID%type
    ,p_LOCATIONNAME in SLLOCATIONS.LOCATIONNAME%type
    ,p_FIELDLENGTH in SLLOCATIONS.FIELDLENGTH%type default null 
    ,p_ISACTIVE in SLLOCATIONS.ISACTIVE%type default null 
    )
    AS
BEGIN
    INSERT INTO games
        VALUES(
            p_LOCATIONID
            ,p_LOCATIONNAME
            ,p_FIELDLENGTH
            ,p_ISACTIVE);
EXCEPTION
    WHEN VALUE_ERROR THEN p_LOCATIONID := -2;
    WHEN OTHERS THEN p_LOCATIONID := -1;
END spslLocationsInsert;

-- Task 1 Part B: UPDATE
CREATE OR REPLACE PROCEDURE spGamesUpdate (
    game_id NUMBER,
    div_id NUMBER,
    game_num NUMBER,
    game_dateTime DATE,
    home_team NUMBER,
    home_score NUMBER,
    visit_team NUMBER,
    visit_score NUMBER,
    location_id NUMBER,
    is_played NUMBER,
    notes_ GAMES.NOTES%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    IF div_ID IS NOT NULL THEN
        UPDATE games
        SET divID = div_id
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF game_num IS NOT NULL THEN
        UPDATE games
        SET gameNum = game_num
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF game_dateTime IS NOT NULL THEN
        UPDATE games
        SET gameDateTime = game_dateTime
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF home_team IS NOT NULL THEN
        UPDATE games
        SET homeTeam = home_team
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF home_score IS NOT NULL THEN
        UPDATE games
        SET homeScore = home_score
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF visit_team IS NOT NULL THEN
        UPDATE games
        SET visitTeam = visit_team
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF visit_score IS NOT NULL THEN
        UPDATE games
        SET visitScore = visit_score
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF location_id IS NOT NULL THEN
        UPDATE games
        SET locationID = location_id
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF is_played IS NOT NULL THEN
        UPDATE games
        SET isPlayed = is_played
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF notes_ IS NOT NULL THEN
        UPDATE games
        SET notes = notes_
        WHERE gameID = game_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
EXCEPTION
    WHEN VALUE_ERROR THEN game_ID := -2;
    WHEN OTHERS THEN status_code := -1;
END spGamesUpdate;

CREATE OR REPLACE PROCEDURE spGoalScorersUpdate (
    goal_id IN goalscorers.goalid%type,
    game_id IN goalscorers.gameid%type,
    player_id IN goalscorers.playerid%type,
    team_id IN goalscorers.teamid%type,
    num_goals IN goalscorers.numgoals%type,
    num_assists IN goalscorers.numassists%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    IF game_id IS NOT NULL THEN
        UPDATE goalscorers
        SET gameid = game_id
        WHERE goalid = goal_id;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF;
    END IF;
    IF player_id IS NOT NULL THEN
        UPDATE goalscorers
        SET playerid = player_id
        WHERE goalid = goal_id;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF;
    END IF;
    IF team_id IS NOT NULL THEN
        UPDATE goalscorers
        SET teamid = team_id
        WHERE goalid = goal_id;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF;
    END IF;
    IF num_goals IS NOT NULL THEN
        UPDATE goalscorers
        SET numgoals = num_goals
        WHERE goalid = goal_id;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF;
    END IF;

    IF num_assists IS NOT NULL THEN
        UPDATE goalscorers
        SET numassists = num_assists
        WHERE goalid = goal_id;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF;
    END IF; 
EXCEPTION
    WHEN OTHERS THEN 
        status_code := -1;
END spGoalScorersUpdate;

CREATE OR REPLACE PROCEDURE spPlayersUpdate (
    player_ID players.playerID%type,
    reg_number players.regNumber%type,
    last_name players.lastName%type,
    first_name players.firstName%type,
    is_active players.isActive%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    IF reg_number IS NOT NULL THEN
        UPDATE players
        SET regNumber = reg_number
        WHERE playerID = player_ID;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF last_name IS NOT NULL THEN
        UPDATE players
        SET lastName = last_name
        WHERE playerID = player_ID;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF first_name IS NOT NULL THEN
        UPDATE players
        SET firstName = first_name
        WHERE playerID = player_ID;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF is_active IS NOT NULL THEN
        UPDATE players
        SET isActive = is_active
        WHERE playerID = player_ID;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN game_ID := -2;
    WHEN OTHERS THEN status_code := -1;
END spPlayersUpdate;

CREATE OR REPLACE PROCEDURE spTeamsUpdate (
    team_id teams.teamid%type,
    team_name teams.teamname%type,
    active teams.isactive%type,
    jersey_color teams.jerseycolour%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    IF team_name IS NOT NULL THEN
        UPDATE teams
        SET teamname = team_name
        WHERE teamid = team_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF active IS NOT NULL THEN
        UPDATE teams
        SET isactive = active
        WHERE teamid = team_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF jersey_color IS NOT NULL THEN
        UPDATE teams
        SET jerseycolour = jersey_color
        WHERE teamid = team_id;
        IF SQL%ROWCOUNT = 1 THEN status_code := status_code + 1;
        END IF; 
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spTeamsUpdate;

CREATE OR REPLACE PROCEDURE spRostersUpdate (
    p_ROSTERID in ROSTERS.ROSTERID%type
    ,p_PLAYERID in ROSTERS.PLAYERID%type default null 
    ,p_TEAMID in ROSTERS.TEAMID%type default null 
    ,p_ISACTIVE in ROSTERS.ISACTIVE%type default null 
    ,p_JERSEYNUMBER in ROSTERS.JERSEYNUMBER%type default null
    ,status_code IN OUT NUMBER
    )
    AS
BEGIN
    IF p_PLAYERID IS NOT NULL THEN
        UPDATE rosters
        SET playerID = p_PLAYERID
        WHERE rosterID = p_ROSTERID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF p_TEAMID IS NOT NULL THEN
        UPDATE rosters
        SET TEAMID = p_TEAMID
        WHERE rosterID = p_ROSTERID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF p_ISACTIVE IS NOT NULL THEN
        UPDATE rosters
        SET ISACTIVE = p_ISACTIVE
        WHERE rosterID = p_ROSTERID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF p_JERSEYNUMBER IS NOT NULL THEN
        UPDATE rosters
        SET JERSEYNUMBER = p_JERSEYNUMBER
        WHERE rosterID = p_ROSTERID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spRostersUpdate;

CREATE OR REPLACE PROCEDURE spslLocationsUpdate (
    p_LOCATIONID in SLLOCATIONS.LOCATIONID%type
    ,p_LOCATIONNAME in SLLOCATIONS.LOCATIONNAME%type
    ,p_FIELDLENGTH in SLLOCATIONS.FIELDLENGTH%type default null 
    ,p_ISACTIVE in SLLOCATIONS.ISACTIVE%type default null 
    ,status_code IN OUT NUMBER
    )
    AS
BEGIN
    IF p_LOCATIONNAME IS NOT NULL THEN
        UPDATE slLocations
        SET LOCATIONNAME = p_LOCATIONNAME
        WHERE LOCATIONID = p_LOCATIONID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF p_FIELDLENGTH IS NOT NULL THEN
        UPDATE slLocations
        SET FIELDLENGTH = p_FIELDLENGTH
        WHERE LOCATIONID = p_LOCATIONID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
    
    IF p_ISACTIVE IS NOT NULL THEN
        UPDATE slLocations
        SET ISACTIVE = p_ISACTIVE
        WHERE LOCATIONID = p_LOCATIONID;
        IF SQL%ROWCOUNT > 0 THEN status_code := status_code + 1;
        END IF; 
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spslLocationsUpdate;

-- Task 1 Part C: DELETE 
CREATE OR REPLACE PROCEDURE spGamesDelete (
    game_ID NUMBER,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM games
    WHERE games.gameID = game_ID;
    IF SQL%ROWCOUNT > 0 THEN
        status_code := game_ID;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spGamesDelete; 

CREATE OR REPLACE PROCEDURE spGoalScorersDelete (
    goal_id NUMBER,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM goalscorers
    WHERE goalscorers.goalid = goal_id;
    IF SQL%ROWCOUNT > 0 THEN
        status_code := goal_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spGoalScorersDelete; 

CREATE OR REPLACE PROCEDURE spPlayersDelete (
    player_ID players.playerID%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM players
    WHERE players.playerID = player_ID;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := player_ID;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spPlayersDelete; 

CREATE OR REPLACE PROCEDURE spTeamsDelete (
    team_id teams.teamid%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM teams
    WHERE teams.teamid = team_id;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := team_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spTeamsDelete; 

CREATE OR REPLACE PROCEDURE spRostersDelete (
    p_ROSTERID in ROSTERS.ROSTERID%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM Rosters
    WHERE rosters.rosterid = p_ROSTERID;
    IF SQL%ROWCOUNT > 0 THEN
        status_code := p_ROSTERID;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spRostersDelete;

CREATE OR REPLACE PROCEDURE spslLocationsDelete (
    p_LOCATIONID in SLLOCATIONS.LOCATIONID%type,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    DELETE 
    FROM slLocations
    WHERE slLocations.locationID = p_LOCATIONID;
    IF SQL%ROWCOUNT > 0 THEN
        status_code := p_LOCATIONID;
    END IF;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spslLocationsDelete; 

-- Task 1 Part D: SELECT
CREATE OR REPLACE PROCEDURE spGamesSelect (
    game_id NUMBER,
    return_game OUT games%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_game
    FROM games
    WHERE games.gameID = game_id;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := game_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spGamesSelect; 

CREATE OR REPLACE PROCEDURE spGoalScorersSelect (
    goal_id NUMBER,
    return_goal OUT goalscorers%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_goal
    FROM goalscorers
    WHERE goalscorers.goalid = goal_id;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := goal_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spGoalScorersSelect; 

CREATE OR REPLACE PROCEDURE spPlayerSelect (
    player_id NUMBER,
    return_player OUT players%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_player
    FROM players
    WHERE players.playerID = player_id;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := player_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spPlayerSelect; 

CREATE OR REPLACE PROCEDURE spTeamsSelect (
    team_id NUMBER,
    return_team OUT teams%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_team
    FROM teams
    WHERE teams.teamid = team_id;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := team_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spTeamsSelect; 

CREATE OR REPLACE PROCEDURE spRostersSelect (
    p_ROSTERID in ROSTERS.ROSTERID%type,
    return_roster OUT rosters%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_game
    FROM rosters
    WHERE rosters.rosterID = p_ROSTERID;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := p_ROSTERID;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spRostersSelect; 

CREATE OR REPLACE PROCEDURE spslLocationsSelect (
    p_LOCATIONID in SLLOCATIONS.LOCATIONID%type,
    return_location OUT slLocations%rowtype,
    status_code IN OUT NUMBER
    ) AS
BEGIN
    SELECT * INTO return_location
    FROM slLocations
    WHERE slLocations.locationID = p_LOCATIONID;
    IF SQL%ROWCOUNT = 1 THEN
        status_code := p_LOCATIONID;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN status_code := -2;
    WHEN TOO_MANY_ROWS THEN status_code := -3;
    WHEN OTHERS THEN status_code := -1;
END spslLocationsSelect; 

-- TASK 2 
CREATE OR REPLACE PROCEDURE spGamesReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM games
        ORDER BY gameid;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Gameid', 6, ' ') || ' ' || RPAD('Divid', 5, ' ')
    || ' ' || RPAD('GameNum', 7, ' ') || ' ' || RPAD('GameDateTime', 12, ' ')
    || ' ' || RPAD('HomeTeam', 8, ' ')|| ' ' || RPAD('HomeScore', 9, ' ')
    || ' ' || RPAD('VisitTeam', 9, ' ')|| ' ' || RPAD('VisitScore', 10, ' ')
    || ' ' || RPAD('LocationID', 10, ' ')|| ' ' || RPAD('isPlayed', 8, ' ')
    || ' ' || RPAD('Notes', 4, ' '));
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.GAMEID, 6, ' ') || ' ' || RPAD(temp.DIVID, 5, ' ')
    || ' ' || RPAD(temp.GAMENUM, 7, ' ') || ' ' || RPAD(temp.GAMEDATETIME, 12, ' ')
    || ' ' || RPAD(temp.HOMETEAM, 8, ' ')|| ' ' || RPAD(temp.HOMESCORE, 9, ' ')
    || ' ' || RPAD(temp.VISITTEAM, 9, ' ')|| ' ' || RPAD(temp.VISITSCORE, 10, ' ')
    || ' ' || RPAD(temp.LOCATIONID, 10, ' ')|| ' ' || RPAD(temp.ISPLAYED, 8, ' ')
    || ' ' || RPAD(temp.NOTES, 4, ' '));
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spGamesReport;

CREATE OR REPLACE PROCEDURE spGoalScorersReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM goalScorers
        ORDER BY goalid;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('GoalID', 6, ' ') || ' ' || RPAD('GameID', 6, ' ')
            || ' ' || RPAD('PlayerID', 8, ' ') || ' ' || RPAD('TeamID', 6, ' ') 
            || ' ' || RPAD('NumGoals', 8, ' ')|| ' ' || RPAD('NumAssists', 10, ' ')
            );
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.GoalID, 6, ' ') || ' ' || RPAD(temp.GameID, 6, ' ')
            || ' ' || RPAD(temp.PlayerID, 8, ' ') || ' ' || RPAD(temp.TeamID, 6, ' ') 
            || ' ' || RPAD(temp.NumGoals, 8, ' ')|| ' ' || RPAD(temp.NumAssists, 10, ' ')
            );
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spGoalScorersReport;

CREATE OR REPLACE PROCEDURE spPlayersReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM Players
        ORDER BY playerID;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('PlayerID', 8, ' ') || ' ' || RPAD('RegNumber', 9, ' ')
            || ' ' || RPAD('LastName', 8, ' ') || ' ' || RPAD('FirstName', 9, ' ') 
            || ' ' || RPAD('isActive', 8, ' ')
            );
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.PlayerID, 8, ' ') || ' ' || RPAD(temp.RegNumber, 9, ' ')
            || ' ' || RPAD(temp.LastName, 8, ' ') || ' ' || RPAD(temp.FirstName, 9, ' ') 
            || ' ' || RPAD(temp.isActive, 8, ' ')
            );
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spPlayersReport;

CREATE OR REPLACE PROCEDURE spTeamsReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM Teams
        ORDER BY teamID;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('TeamID', 6, ' ') || ' ' || RPAD('TeamName', 9, ' ')
            || ' ' || RPAD('isActive', 8, ' ') || ' ' || RPAD('JerseyColour', 12, ' ') 
            );
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.TeamID, 6, ' ') || ' ' || RPAD(temp.TeamName, 9, ' ')
            || ' ' || RPAD(temp.isActive, 8, ' ') || ' ' || RPAD(temp.JerseyColour, 12, ' ') 
            );
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spTeamsReport;

CREATE OR REPLACE PROCEDURE spRostersReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM Rosters
        ORDER BY rosterID;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('RosterID', 8, ' ') || ' ' || RPAD('PlayerID', 8, ' ')
            || ' ' || RPAD('TeamID', 6, ' ') || ' ' || RPAD('isActive', 8, ' ') || ' ' ||
            RPAD('JerseyNumber', 12, ' ') 
            );
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.RosterID, 8, ' ') || ' ' || RPAD(temp.PlayerID, 8, ' ')
            || ' ' || RPAD(temp.TeamID, 6, ' ') || ' ' || RPAD(temp.isActive, 8, ' ') || ' ' ||
            RPAD(temp.JerseyNumber, 12, ' ') 
            );
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spRostersReport;

CREATE OR REPLACE PROCEDURE spslLocationsReport (
    status_code IN OUT NUMBER
    )AS
    CURSOR the_table IS
        SELECT * FROM slLocations
        ORDER BY locationID;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('LocationID', 10, ' ') || ' ' || RPAD('LocationName', 12, ' ')
            || ' ' || RPAD('FieldLength', 11, ' ') || ' ' || RPAD('isActive', 8, ' ')
            );
    FOR temp IN the_table
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.LocationID, 10, ' ') || ' ' || RPAD(temp.LocationName, 12, ' ')
            || ' ' || RPAD(temp.FieldLength, 11, ' ') || ' ' || RPAD(temp.isActive, 8, ' ')
            );
    status_code := status_code + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN status_code := -1;
END spslLocationsReport;

-- TASK 3
CREATE OR REPLACE VIEW vwPlayerRosters AS
SELECT 
    p.playerID, 
    regNumber, 
    lastName,
    firstName,
    p.isActive AS PLAYER_ACTIVE,
    rosterID,
    t.teamID,
    t.teamName,
    t.isActive AS TEAM_ACTIVE,
    jerseyNumber,
    jerseyColour
FROM players p JOIN rosters r ON p.playerID = r.playerID
    RIGHT JOIN teams t ON t.teamID = r.teamID;

-- TASK 4
CREATE OR REPLACE PROCEDURE spTeamRosterByID (
    team_id NUMBER,
    scode IN OUT NUMBER
    ) AS
    CURSOR team_info IS
        SELECT *
        FROM vwPlayerRosters
        WHERE teamID = team_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Players on team number ' || team_id);
    DBMS_OUTPUT.PUT_LINE(RPAD('PlayerID', 8, ' ') || ' ' || RPAD('RegNum', 6, ' ')
    || ' ' || RPAD('LastName', 15, ' ') || ' ' || RPAD('FirstName', 15, ' ')
    || ' ' || RPAD('JerseyNum', 9, ' ') || ' ' || RPAD('JerseyColour', 12, ' '));
    FOR temp IN team_info
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(temp.PlayerID, 8, ' ') || ' ' || 
        RPAD(temp.RegNumber, 6, ' ') || ' ' || RPAD(temp.LastName, 15, ' ') || ' ' || 
        RPAD(temp.FirstName, 15, ' ') || ' ' || RPAD(temp.jerseyNumber, 9, ' ')
        || ' ' || RPAD(temp.JerseyColour, 12, ' '));
        scode := scode + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        scode := -1;
END spTeamRosterByID;

-- TASK 5
CREATE OR REPLACE PROCEDURE spTeamRosterByName (
    team_name TEAMS.TEAMNAME%type,
    scode IN OUT NUMBER
    ) AS
    CURSOR team_info IS
        SELECT *
        FROM vwPlayerRosters
        WHERE LOWER(teamName) LIKE '%'|| TRIM(LOWER(team_name))||'%';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Players on team ' || team_name);
    DBMS_OUTPUT.PUT_LINE(RPAD('PlayerID', 8, ' ') || ' ' || RPAD('RegNum', 6, ' ')
    || ' ' || RPAD('LastName', 15, ' ') || ' ' || RPAD('FirstName', 15, ' ')
    || ' ' || RPAD('TeamName', 8, ' ') || ' ' || RPAD('JerseyNum', 9, ' ') 
    || ' ' || RPAD('JerseyColour', 12, ' '));
    FOR temp IN team_info
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(temp.PlayerID, 8, ' ') || ' ' || 
        RPAD(temp.RegNumber, 6, ' ') || ' ' || RPAD(temp.LastName, 15, ' ') || ' ' || 
        RPAD(temp.FirstName, 15, ' ') || ' ' || RPAD(temp.TeamName, 8, ' ') 
        || ' ' || RPAD(temp.jerseyNumber, 9, ' ') || ' ' || RPAD(temp.JerseyColour, 12, ' '));
        scode := scode + 1;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        scode := -1;
END spTeamRosterByName;

-- Task 6
CREATE OR REPLACE VIEW vwTeamsNumPlayers AS 
SELECT 
    count(playerID) AS num_players,
    t.teamID AS team_id
FROM rosters r RIGHT JOIN teams t ON r.teamID = t.teamID
GROUP BY t.teamID;
    
-- TASK 7
CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID (teamPK teams.teamID%type) 
    RETURN NUMBER IS
        rtn_numPlayers NUMBER;
BEGIN
    SELECT num_players INTO rtn_numPlayers
    FROM vwTeamsNumPlayers
    WHERE team_id = teamPK;
    RETURN rtn_numPlayers;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -3;
    WHEN TOO_MANY_ROWS THEN
        RETURN -2;
    WHEN OTHERS THEN
        RETURN -1;
END fncNumPlayersByTeamID;

-- TASK 8
CREATE OR REPLACE VIEW vwSchedule AS
SELECT
    gameID,
    divID,
    gameNum,
    gameDateTime,
    ht.teamName AS homeTeam,
    homeScore,
    vt.teamName AS visitTeam,
    visitScore,
    locationName,
    isPlayed,
    notes
FROM games g INNER JOIN teams ht ON g.homeTeam = ht.teamID
    INNER JOIN teams vt ON g.visitTeam = vt.teamID
    INNER JOIN slLocations l ON g.locationID = l.locationID;

-- Task 9
CREATE OR REPLACE PROCEDURE spSchedUpcomingGames (
    num_days NUMBER
    ) AS
    num_rows NUMBER := 0;
    CURSOR gameDetails IS 
        SELECT *
        FROM vwschedule
        WHERE TRUNC(gamedatetime, 'DDD') - TRUNC(sysdate, 'DDD')
            BETWEEN 0 AND num_days
            AND isPlayed = 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Gameid', 6, ' ') || ' ' || RPAD('Divid', 5, ' ')
    || ' ' || RPAD('GameNum', 7, ' ') || ' ' || RPAD('GameDateTime', 12, ' ')
    || ' ' || RPAD('HomeTeam', 8, ' ')|| ' ' || RPAD('HomeScore', 9, ' ')
    || ' ' || RPAD('VisitTeam', 9, ' ')|| ' ' || RPAD('VisitScore', 10, ' ')
    || ' ' || RPAD('Location', 22, ' ')|| ' ' || RPAD('isPlayed', 8, ' ')
    || ' ' || RPAD('Notes', 4, ' '));
    
    FOR temp IN gameDetails
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(temp.GAMEID, 6, ' ') || ' ' || RPAD(temp.DIVID, 5, ' ')
        || ' ' || RPAD(temp.GAMENUM, 7, ' ') || ' ' || RPAD(temp.GAMEDATETIME, 12, ' ')
        || ' ' || RPAD(temp.HOMETEAM, 8, ' ')|| ' ' || RPAD(temp.HOMESCORE, 9, ' ')
        || ' ' || RPAD(temp.VISITTEAM, 9, ' ')|| ' ' || RPAD(temp.VISITSCORE, 10, ' ')
        || ' ' || RPAD(temp.LOCATIONNAME, 22, ' ')|| ' ' || RPAD(temp.ISPLAYED, 8, ' ')
        || ' ' || RPAD(temp.NOTES, 4, ' '));
        num_rows := num_rows + 1;
    END LOOP;
    IF num_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No games found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred.');
END spSchedUpcomingGames;

-- TASK 10
CREATE OR REPLACE PROCEDURE spSchedPastGames (
    num_days NUMBER
    ) AS
    num_rows NUMBER := 0;
    CURSOR gameDetails IS 
        SELECT *
        FROM vwschedule
        WHERE TRUNC(sysdate, 'DDD') - TRUNC(gamedatetime, 'DDD')
            BETWEEN 0 AND num_days
            AND isPlayed = 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Gameid', 6, ' ') || ' ' || RPAD('Divid', 5, ' ')
    || ' ' || RPAD('GameNum', 7, ' ') || ' ' || RPAD('GameDateTime', 12, ' ')
    || ' ' || RPAD('HomeTeam', 8, ' ')|| ' ' || RPAD('HomeScore', 9, ' ')
    || ' ' || RPAD('VisitTeam', 9, ' ')|| ' ' || RPAD('VisitScore', 10, ' ')
    || ' ' || RPAD('Location', 22, ' ')|| ' ' || RPAD('isPlayed', 8, ' ')
    || ' ' || RPAD('Notes', 4, ' '));
    FOR temp IN gameDetails
    LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(temp.GAMEID, 6, ' ') || ' ' || RPAD(temp.DIVID, 5, ' ')
    || ' ' || RPAD(temp.GAMENUM, 7, ' ') || ' ' || RPAD(temp.GAMEDATETIME, 12, ' ')
    || ' ' || RPAD(temp.HOMETEAM, 8, ' ')|| ' ' || RPAD(temp.HOMESCORE, 9, ' ')
    || ' ' || RPAD(temp.VISITTEAM, 9, ' ')|| ' ' || RPAD(temp.VISITSCORE, 10, ' ')
    || ' ' || RPAD(temp.LOCATIONNAME, 22, ' ')|| ' ' || RPAD(temp.ISPLAYED, 8, ' ')
    || ' ' || RPAD(temp.NOTES, 4, ' '));
    num_rows := num_rows + 1;
    END LOOP;
    IF num_rows = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No games found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred.');
END spSchedPastGames;

-- Task 11
CREATE OR REPLACE VIEW vwNumGamesWon AS
SELECT
    teamid,
    teamname,
    nvl((SELECT count(gameid)
        FROM games
        WHERE isplayed = 1 AND
            homescore > visitscore AND
            hometeam = t.teamid
        GROUP BY hometeam),0) + nvl((SELECT count(gameid)
        FROM games
        WHERE isplayed = 1 AND
            homescore < visitscore AND
            visitteam = t.teamid
        GROUP BY visitteam),0) AS gamesWON
FROM teams t
ORDER BY gamesWON DESC;

CREATE OR REPLACE FUNCTION fncNumGamesWon(teamPK teams.teamID%type) 
    RETURN NUMBER IS
        rtn_numGamesWon NUMBER;
BEGIN
    SELECT gamesWon INTO rtn_numGamesWon
    FROM vwNumGamesWon 
    WHERE teamID = teamPK;
    RETURN rtn_numGamesWon;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -2;
    WHEN TOO_MANY_ROWS THEN 
        RETURN -3;
    WHEN OTHERS THEN
        RETURN -1;
END fncNumGamesWon;
    
    
    