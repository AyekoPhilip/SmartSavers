table 50274 "Approvals Delegation"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Delegation No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Delegation No.';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50010; "Current User"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'Current User';
        }
        field(50011; "Reason for Delegation"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason for Delegation';
        }
        field(50012; "Delegated To"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'Delegated To';
        }
        field(50013; "Status"; Option)
        {
            OptionCaption = 'Open,Delegated,Resumed';
            OptionMembers = "Open","Delegated","Resumed";
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(50014; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
        field(50015; "Delegation Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Delegation Start Date';
        }
        field(50016; "Date-Time Delegated"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date-Time Delegated';
        }
        field(50017; "Date-Time Resumed"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date-Time Resumed';
        }
        field(50018; "Delegation End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Delegation End Date';
        }
        field(50019; "Sequence No."; Integer)
        {
            MinValue = 1;
            DataClassification = CustomerContent;
            Caption = 'Sequence No.';
        }
    }

    keys
    {
        key("Key1"; "Delegation No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        CashMgt.Get();
        CashMgt.TestField("Approvals Delegation Nos.");
        if "Delegation No." = '' then begin

        end;
        "Current User" := UserId;
    end;

    var
        CashMgt: Record "Cash Management Setups";
        ApprovalDelegations: Report "Approval Delegations";
        ApprovalDelegationsResume: Report "Approval Delegations Resume";
        NoSeriesMgt: Codeunit "No. Series";
        SequenceNo: Integer;
        Text000: Label 'Are you sure you want to delegate your approvals to %1?';
        Text001: Label 'Are you sure you want to resume your approvals from %1?';
        Text002: Label 'Delegation %1 has been %2';

    procedure Delegate(DelegationRec: Record "Approvals Delegation")
    var
        UserRec: Record User;
        UserSetup: Record "User Setup";
        WFlowGroupUsers: Record "Workflow User Group Member";
        Username: Text;
    begin
        DelegationRec.TestField("Current User");
        DelegationRec.TestField("Delegated To");
        DelegationRec.TestField(Status, DelegationRec.Status::Open);
        DelegationRec.TestField("Delegation Start Date");
        DelegationRec.TestField("Delegation End Date");
        UserRec.Reset();
        UserRec.SetRange("User Name", DelegationRec."Delegated To");
        if UserRec.Find('-') then;

        if UserRec."Full Name" <> '' then
            Username := UserRec."Full Name"
        else
            Username := DelegationRec."Delegated To";

        if Confirm(Text000, false, Username) then begin
            //Change Approval Setups
            UserSetup.Reset();
            UserSetup.SetRange("Approver ID", DelegationRec."Current User");
            if UserSetup.Find('-') then
                repeat
                    UserSetup."Approver ID" := DelegationRec."Delegated To";
                    UserSetup."Delegated From" := DelegationRec."Current User";
                    UserSetup.Modify();
                until
                 UserSetup.Next() = 0;

            WFlowGroupUsers.Reset();
            WFlowGroupUsers.SetRange("User Name", DelegationRec."Current User");
            if WFlowGroupUsers.Find('-') then
                repeat
                    WFlowGroupUsers."Delegated From" := DelegationRec."Current User";
                    SequenceNo := WFlowGroupUsers."Sequence No.";
                    DelegationRec.Validate("Sequence No.", SequenceNo);
                    WFlowGroupUsers.Rename(WFlowGroupUsers."Workflow User Group Code", DelegationRec."Delegated To", DelegationRec."Sequence No.");
                until
                 WFlowGroupUsers.Next() = 0;

            //Modify Existing Entries
            // ApprovalEntry.RESET;
            // ApprovalEntry.SETRANGE("Approver ID","Current User");
            // ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Open,ApprovalEntry.Status::Created);
            // IF ApprovalEntry.FIND('-') THEN
            //   REPEAT
            //     ApprovalEntry."Approver ID":="Delegated To";
            //     ApprovalEntry."Delegated From":="Current User";
            //     ApprovalEntry.MODIFY;
            //   UNTIL
            //    ApprovalEntry.NEXT=0;
            Commit();

            //New Modify:
            ApprovalDelegations.GetDefaults(DelegationRec."Current User", DelegationRec."Delegated To");
            ApprovalDelegations.Run();
            //  OpenDelegations.SendDelegationEmail(DelegationRec);
            DelegationRec.Status := DelegationRec.Status::Delegated;
            DelegationRec.Modify();
            Message(Text002, DelegationRec."Delegation No.", 'Delegated Sucessfully!');

        end;
    end;

    procedure Resume(var DelegationRec: Record "Approvals Delegation")
    var
        UserRec: Record User;
        UserSetup: Record "User Setup";
        WFlowGroupUsers: Record "Workflow User Group Member";
        Username: Text;
    begin
        DelegationRec.TestField("Current User");
        DelegationRec.TestField("Delegated To");
        DelegationRec.TestField(Status, DelegationRec.Status::Delegated);
        DelegationRec.TestField("Delegation Start Date");
        DelegationRec.TestField("Delegation End Date");
        UserRec.Reset();
        UserRec.SetRange("User Name", DelegationRec."Delegated To");
        if UserRec.Find('-') then;

        if UserRec."Full Name" <> '' then
            Username := UserRec."Full Name"
        else
            Username := DelegationRec."Delegated To";

        if Confirm(Text001, false, Username) then begin
            //Change Approval Setups
            UserSetup.Reset();
            UserSetup.SetRange("Approver ID", DelegationRec."Delegated To");
            UserSetup.SetRange("Delegated From", DelegationRec."Current User");
            if UserSetup.Find('-') then
                repeat
                    UserSetup."Approver ID" := DelegationRec."Current User";
                    UserSetup."Delegated From" := '';
                    UserSetup.Modify();
                until
                 UserSetup.Next() = 0;

            WFlowGroupUsers.Reset();
            WFlowGroupUsers.SetRange("User Name", DelegationRec."Delegated To");
            WFlowGroupUsers.SetRange("Delegated From", DelegationRec."Current User");
            if WFlowGroupUsers.Find('-') then
                repeat
                    WFlowGroupUsers."Delegated From" := '';
                    SequenceNo := WFlowGroupUsers."Sequence No.";
                    DelegationRec.Validate("Sequence No.", SequenceNo);
                    WFlowGroupUsers.Rename(WFlowGroupUsers."Workflow User Group Code", DelegationRec."Current User", DelegationRec."Sequence No.");
                until
                 WFlowGroupUsers.Next() = 0;

            // //Modify Existing Entries
            // ApprovalEntry.RESET;
            // ApprovalEntry.SETCURRENTKEY(Status);
            // ApprovalEntry.SETRANGE("Approver ID","Delegated To");
            // ApprovalEntry.SETRANGE("Delegated From","Current User");
            // ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Open,ApprovalEntry.Status::Created);
            // IF ApprovalEntry.FIND('-') THEN
            //   REPEAT
            //     ApprovalEntry."Approver ID":="Current User";
            //     ApprovalEntry."Delegated From":='';
            //     ApprovalEntry.MODIFY;
            //   UNTIL
            //    ApprovalEntry.NEXT=0;

            Commit();
            //Resume New
            ApprovalDelegationsResume.GetDefaults(DelegationRec."Delegated To", DelegationRec."Current User");
            ApprovalDelegationsResume.Run();
            //    OpenDelegations.SendResumptionEmail(DelegationRec);
            DelegationRec.Status := DelegationRec.Status::Resumed;
            DelegationRec.Modify();
            Message(Text002, DelegationRec."Delegation No.", 'Resumed Sucessfully!');
        end;
    end;
}


