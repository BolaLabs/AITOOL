/*
    AITOOL — tables the addon keeps in the company database.

    The addon creates these on first use, which needs CREATE TABLE on the database and ALTER
    on the dbo schema. Plenty of installations do not grant that to the login the ERP connects
    with, and until this script existed the only way to find out was a write that went through
    with no audit line behind it. Run this once, as db_owner, and the addon needs no DDL rights
    at runtime: the IF NOT EXISTS checks pass and nothing is created.

    Run against the company database (PRI<CompanyCode>), once per company.
    Idempotent: safe to run again after an upgrade.

    Usage:
        sqlcmd -S <server> -d PRI<CompanyCode> -i sql\AI_Schema.sql
*/

SET NOCOUNT ON;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AI_ChatSessions')
BEGIN
    CREATE TABLE AI_ChatSessions (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        UserId NVARCHAR(100) NOT NULL,
        CompanyCode NVARCHAR(20) NOT NULL,
        Title NVARCHAR(200) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
        UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_ChatSessions_User ON AI_ChatSessions(UserId, CompanyCode, UpdatedAt DESC);
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AI_ChatMessages')
BEGIN
    CREATE TABLE AI_ChatMessages (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        SessionId UNIQUEIDENTIFIER NOT NULL,
        Role NVARCHAR(20) NOT NULL,
        Content NVARCHAR(MAX) NOT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_ChatMessages_Session ON AI_ChatMessages(SessionId, CreatedAt);
END
GO

/*
    Every ERP write the assistant performs is recorded here, successes and refusals alike.
    The addon never updates or deletes a row, which is why the grants below are narrower for
    this table than for the two above.
*/
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AI_AuditLog')
BEGIN
    CREATE TABLE AI_AuditLog (
        Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
        Timestamp DATETIME2 NOT NULL DEFAULT GETDATE(),
        UserId NVARCHAR(100) NOT NULL,
        CompanyCode NVARCHAR(20) NOT NULL,
        ToolName NVARCHAR(100) NOT NULL,
        Summary NVARCHAR(400) NOT NULL,
        Success BIT NOT NULL,
        Detail NVARCHAR(MAX) NULL,
        SessionId UNIQUEIDENTIFIER NULL
    );
    CREATE INDEX IX_AuditLog_Company ON AI_AuditLog(CompanyCode, Timestamp DESC);
END

-- Upgrade guards: a table created by an earlier version of this script gains the columns a
-- newer addon build writes. Idempotent; only nullable/defaulted columns are ever listed.
IF COL_LENGTH('dbo.AI_ChatSessions','UpdatedAt') IS NULL
    ALTER TABLE AI_ChatSessions ADD UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE();
IF COL_LENGTH('dbo.AI_ChatMessages','UsedInContext') IS NULL
    ALTER TABLE AI_ChatMessages ADD UsedInContext BIT NOT NULL DEFAULT 1;
IF COL_LENGTH('dbo.AI_AuditLog','Detail') IS NULL
    ALTER TABLE AI_AuditLog ADD Detail NVARCHAR(MAX) NULL;
IF COL_LENGTH('dbo.AI_AuditLog','SessionId') IS NULL
    ALTER TABLE AI_AuditLog ADD SessionId UNIQUEIDENTIFIER NULL;
GO

/*
    Minimum rights the addon needs once the tables exist. Replace the principal with the login
    the ERP connects with, then uncomment.

    No DDL is required after this point.
*/
-- GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.AI_ChatSessions TO [<erp_login>];
-- GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.AI_ChatMessages TO [<erp_login>];
-- GRANT SELECT, INSERT                 ON dbo.AI_AuditLog     TO [<erp_login>];
GO
