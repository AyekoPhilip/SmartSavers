report 50171 "Approval Delegations Resume"
{
    Permissions = tabledata "Approval Entry" = rimd;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Approval Entry"; "Approval Entry")
        {
            trigger OnAfterGetRecord()
            begin
                "Approval Entry"."Approver ID" := CurrUser;
                "Approval Entry"."Delegated From" := '';
                "Approval Entry".Modify();
            end;

            trigger OnPreDataItem()
            begin
                "Approval Entry".SetCurrentKey("Approval Entry".Status);
                "Approval Entry".SetRange("Approval Entry"."Approver ID", DelUser);
                "Approval Entry".SetRange("Approval Entry"."Delegated From", CurrUser);
                "Approval Entry".SetFilter("Approval Entry".Status, '%1|%2', "Approval Entry".Status::Open, "Approval Entry".Status::Created);
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
        }
    }
    labels
    {
    }

    var
        CurrUser: Code[50];
        DelUser: Code[50];

    procedure GetDefaults(DelegatedUser: Code[50]; CurrentUser: Code[50])
    begin
        DelUser := DelegatedUser;
        CurrUser := CurrentUser;
    end;
}


