report 50344 "Change Logs-Phone Nos"
{
    ApplicationArea = All;
    Caption = 'Change Logs-Phone Nos';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/ChangeLogsPhoneNumbers.rdl';
    UseRequestPage = true;
    dataset
    {
        dataitem(ChangeLogEntry; "Change Log Entry")
        {
            DataItemTableView=where("Table No."=filter(52147175));
            column(DateandTime; "Date and Time")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(FieldCaption; "Field Caption")
            {
            }
            column(FieldLogEntryFeature; "Field Log Entry Feature")
            {
            }
            column(FieldNo; "Field No.")
            {
            }
            column(NewValue; "New Value")
            {
            }
            column(NotificationMessageId; "Notification Message Id")
            {
            }
            column(NotificationStatus; "Notification Status")
            {
            }
            column(OldValue; "Old Value")
            {
            }
            column(PrimaryKey; "Primary Key")
            {
            }
            column(PrimaryKeyField1Caption; "Primary Key Field 1 Caption")
            {
            }
            column(PrimaryKeyField1No; "Primary Key Field 1 No.")
            {
            }
            column(PrimaryKeyField1Value; "Primary Key Field 1 Value")
            {
            }
            column(PrimaryKeyField2Caption; "Primary Key Field 2 Caption")
            {
            }
            column(PrimaryKeyField2No; "Primary Key Field 2 No.")
            {
            }
            column(PrimaryKeyField2Value; "Primary Key Field 2 Value")
            {
            }
            column(PrimaryKeyField3Caption; "Primary Key Field 3 Caption")
            {
            }
            column(PrimaryKeyField3No; "Primary Key Field 3 No.")
            {
            }
            column(PrimaryKeyField3Value; "Primary Key Field 3 Value")
            {
            }
            column(Protected; "Protected")
            {
            }
            column(TableCaption; "Table Caption")
            {
            }
            column(TableNo; "Table No.")
            {
            }
            column(Time; "Time")
            {
            }
            column(TypeofChange; "Type of Change")
            {
            }
            column(UserID; "User ID")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}



