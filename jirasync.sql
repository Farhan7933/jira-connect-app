    CREATE TABLE jira_project
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        project_id          varchar(30)		        UNIQUE NOT NULL,
        key                 varchar(30)		        UNIQUE NOT NULL,
        name                varchar(30)		        NOT NULL,
        self_url            text                            ,
        project_type_key    varchar(20)             NOT NULL,
        style               varchar(20)             NOT NULL,
        simplified          boolean        	        DEFAULT FALSE,
        is_private          boolean        	        DEFAULT FALSE,
        project_keys        text[],
        insight             jsonb,
        customer_id         bigint                  NOT NULL,
        created_at          TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
        org_id              bigint,
        org_name            varchar(20),
        avatar_urls         jsonb,
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_board
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        board_id            varchar(30)		        UNIQUE NOT NULL,
        name                varchar(30)		        NOT NULL,
        type                varchar(10)             CHECK (type IN ('kanban', 'scrum')),
        display_name        varchar(30),
        project_name        varchar(30),
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        org_id              bigint,
        org_name            varchar(20),
        is_private          boolean,
        self_url            text,
        avatar_uri          text,
        created_at          TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') NOT NULL,
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_board_configs
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        board_id            varchar(30)             REFERENCES board(board_id) ON DELETE CASCADE,
        jira_board_type     varchar(10)             CHECK (type IN ('kanban', 'scrum')),
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        name                varchar(20),
        self_url            text,
        filter              jsonb,
        org_id              bigint,
        org_name            varchar(20),
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_board_statuses
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        status_id           varchar(20)		        NOT NULL,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        board_id            varchar(20)             REFERENCES board(board_id) ON DELETE CASCADE,
        status_url          text,
        org_id              bigint,
        org_name            varchar(20),
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_issue_type
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        issue_id            varchar(20)		        NOT NULL,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        description         text,
        name                varchar(20)             NOT NULL),
        self_url            text,
        icon_url            text,
        hierarchyLevel      bigint,
        avatar_id           bigint,
        org_id              bigint,
        org_name            varchar(20),
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_sprint
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        sprint_id           bigint		            UNIQUE NOT NULL,
        name                varchar(30) 		    NOT NULL,
        state               varchar(10)             CHECK (state IN ('active', 'closed', 'future')),
        start_date          TIMESTAMPTZ,
        end_date            TIMESTAMPTZ,
        created_date        TIMESTAMPTZ,
        board_id     varchar(30)                    REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        goal                text,
        org_id              bigint,
        org_name            varchar(20),
        self_url            text,
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_sprint_issue
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        issue_id            varchar(30),		    UNIQUE NOT NULL,
        key                 varchar(30),		    NOT NULL,
        issue_type_id       varchar(30)             REFERENCES issue_type(issue_id),
        issue_type_name     varchar(30),
        statuscategorychangedate TIMESTAMPTZ,
        timespent           jsonb,
        sprint_id           bigint                  REFERENCES sprint(sprint_id) ON DELETE CASCADE,
        sprint_name         varchar(30),
        sprint_state        varchar(10)             CHECK (state IN ('active', 'closed', 'future')),
        board_id            varchar(30)             REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        project_name        varchar(30),
        aggregatetimespent  jsonb,
        resolution_id       varchar(10),
        resolution_self_url text,
        resolution_name     varchar(20),
        resolution_description text,
        resolution_date     TIMESTAMPTZ,
        priority_id         varchar(10),
        priority_name       varchar(20),
        epic                jsonb,
        priority_icon_url   text,
        priority_self_url   text,
        labels              text[],
        timeestimate        jsonb,
        aggregatetimeoriginalestimate jsonb,
        issuelinks          jsonb,
        assignee_id         varchar(20),
        assignee_email_address varchar(20),
        assignee_display_name varchar(20),
        assignee_active     boolean,
        status_id           varchar(20),
        status_name         varchar(20),
        status_description  text,
        status_self_url     text,
        timeoriginalestimate jsonb,
        summary            text,
        description        text,
        created            TIMESTAMPTZ,
        updated            TIMESTAMPTZ,
        issue_self_url     text,
        org_id             bigint,
        org_name           varchar(20),
        PRIMARY KEY (id)
    );

    CREATE TABLE jira_kanban_issue
    (
        id                  bigint         	   	    NOT NULL GENERATED ALWAYS AS IDENTITY,
        issue_id            varchar(30),		    UNIQUE NOT NULL,
        key                 varchar(30),		    NOT NULL,
        issue_self_url      text,
        issue_type_id       varchar(30)             REFERENCES issue_type(issue_id),
        issue_type_name     varchar(30),
        statuscategorychangedate TIMESTAMPTZ,
        resolution_id       varchar(10),
        resolution_self_url text,
        resolution_name     varchar(20),
        resolution_description text,
        resolution_date     TIMESTAMPTZ,
        epic                jsonb,
        priority_id         varchar(10),
        priority_name       varchar(20),
        priority_icon_url   text,
        priority_self_url   text,
        aggregatetimeoriginalestimate jsonb,
        timeestimate        jsonb,
        assignee_id         varchar(20),
        assignee_email_address varchar(20),
        assignee_display_name varchar(20),
        assignee_active     boolean,
        status_id           varchar(20),
        status_name         varchar(20),
        status_description  text,
        status_self_url     text,
        created            TIMESTAMPTZ,
        updated            TIMESTAMPTZ,
        summary            text,
        org_id             bigint,
        org_name           varchar(20),
        board_id           varchar(30)              REFERENCES board(board_id) ON DELETE CASCADE,
        project_id          varchar(30)             REFERENCES project(project_id) ON DELETE CASCADE,
        PRIMARY KEY (id)
    );