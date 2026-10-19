report 50170 "Approval Delegations"
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
                "Approval Entry"."Approver ID" := DelUser;
                "Approval Entry"."Delegated From" := CurrUser;
                "Approval Entry".Modify();
            end;

            trigger OnPreDataItem()
            begin
                "Approval Entry".SetRange("Approval Entry"."Approver ID", CurrUser);
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

    procedure GetDefaults(CurrentUser: Code[50]; DelegatedUser: Code[50])
    begin
        CurrUser := CurrentUser;
        DelUser := DelegatedUser;
    end;
}


