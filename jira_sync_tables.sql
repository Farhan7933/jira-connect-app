    CREATE TABLE jira_project
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        customer_id         bigint                  NOT NULL,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        base_url            text                    NOT NULL,
        project_id          text		            NOT NULL,
        project_key         text		            NOT NULL,
        project_name        text		            NOT NULL,
        self_url            text                    ,
        project_type_key    text                    NOT NULL,
        style               text                    NOT NULL,
        simplified          boolean        	        DEFAULT FALSE,
        is_private          boolean        	        DEFAULT FALSE,
        project_keys        text[],
        insight             jsonb,
        created_at          TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
        avatar_urls         jsonb,
        PRIMARY KEY (id),
        UNIQUE(project_id),
        UNIQUE(project_key)
    );

    CREATE TABLE jira_board
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        base_url            text                    NOT NULL,
        board_id            text		            NOT NULL,
        board_name          text		            NOT NULL,
        board_type          varchar(10)             CHECK (type IN ('kanban', 'scrum')),
        display_name        text                    NOT NULL,
        project_name        text                    NOT NULL,
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        is_private          boolean,
        self_url            text,
        avatar_uri          text,
        created_at          TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
        PRIMARY KEY (id),
        UNIQUE(project_id, board_id)
    );

    CREATE TABLE jira_board_configs
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        base_url            text                    NOT NULL,
        board_id            text                    REFERENCES board(board_id) ON DELETE CASCADE,
        jira_board_type     text                    CHECK (type IN ('kanban', 'scrum')),
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        name                varchar(50),
        self_url            text,
        filter              jsonb,
        PRIMARY KEY (id),
        UNIQUE(project_id, board_id, name)
    );

    CREATE TABLE jira_board_statuses
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        base_url            text                    NOT NULL,
        status_id           text		            NOT NULL,
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        board_id            text                    REFERENCES board(board_id) ON DELETE CASCADE,
        status_url          text,
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_issue_type
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        base_url            text                    NOT NULL,
        issue_type_id       text		            NOT NULL,
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        description         text,
        issue_type_name     text                    NOT NULL,
        self_url            text,
        icon_url            text,
        hierarchy_level     bigint,
        avatar_id           bigint,
        PRIMARY KEY (id),
        UNIQUE(project_id, issue_type_id)
    );

    CREATE TABLE jira_sprint
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        sprint_id           bigint		            UNIQUE NOT NULL,
        base_url            text                    NOT NULL,
        sprint_name         text 		            NOT NULL,
        sprint_state        varchar(10)             CHECK (state IN ('active', 'closed', 'future')),
        start_date          TIMESTAMPTZ,
        end_date            TIMESTAMPTZ,
        created_date        TIMESTAMPTZ,
        board_id            text                    REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        goal                text,
        self_url            text,
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_sprint_issue
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        org_name            text                    NOT NULL,
        issue_id            text,		            NOT NULL,
        sprint_id           bigint                  REFERENCES sprint(sprint_id) ON DELETE CASCADE,
        board_id            text                    REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          text                    REFERENCES project(project_id) ON DELETE CASCADE,
        base_url            text                    NOT NULL,
        issue_key           text,		            NOT NULL,
        issue_type_id       text                    REFERENCES issue_type(issue_id),
        issue_type_name     text,
        statuscategorychangedate TIMESTAMPTZ,
        timespent           jsonb,
        sprint_name         text,
        sprint_state        varchar(10)             CHECK (state IN ('active', 'closed', 'future')),
        project_name        text,
        aggregatetimespent  jsonb,
        resolution_id       text,
        resolution_self_url text,
        resolution_name     text,
        resolution_description text,
        resolution_date     TIMESTAMPTZ,
        priority_id         text,
        priority_name       text,
        epic                jsonb,
        priority_icon_url   text,
        priority_self_url   text,
        labels              text[],
        timeestimate        jsonb,
        aggregatetimeoriginalestimate jsonb,
        issuelinks          jsonb,
        assignee_id         text,
        assignee_email_address text,
        assignee_display_name text,
        assignee_active     boolean,
        status_id           text,
        status_name         text,
        status_description  text,
        status_self_url     text,
        timeoriginalestimate jsonb,
        summary            text,
        description        text,
        created            TIMESTAMPTZ,
        updated            TIMESTAMPTZ,
        issue_self_url     text,
        PRIMARY KEY (id),
        UNIQUE(project_id, board_id, sprint_id, issue_id)
    );

    CREATE TABLE jira_kanban_issue
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        account_id          text                    NOT NULL,
        board_id            varchar(30)             REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        org_name            text                    NOT NULL,
        issue_id            text,		            NOT NULL,
        base_url            text                    NOT NULL,
        issue_key           text,		            NOT NULL,
        issue_self_url      text,
        issue_type_id       text                    REFERENCES issue_type(issue_id),
        issue_type_name     text,
        statuscategorychangedate TIMESTAMPTZ,
        resolution_id       text,
        resolution_self_url text,
        resolution_name     text,
        resolution_description text,
        resolution_date     TIMESTAMPTZ,
        epic                jsonb,
        priority_id         text,
        priority_name       text,
        priority_icon_url   text,
        priority_self_url   text,
        aggregatetimeoriginalestimate jsonb,
        timeestimate        jsonb,
        assignee_id         text,
        assignee_email_address text,
        assignee_display_name text,
        assignee_active     boolean,
        status_id           text,
        status_name         text,
        status_description  text,
        status_self_url     text,
        created            TIMESTAMPTZ,
        updated            TIMESTAMPTZ,
        summary            text,
        PRIMARY KEY (id),
        UNIQUE(project_id, board_id, issue_id)
    );