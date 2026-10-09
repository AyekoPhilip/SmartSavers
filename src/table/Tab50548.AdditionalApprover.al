table 50548 "Additional Approver"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
            TableRelation = "Approval Template"."Approval Code";
            DataClassification = CustomerContent;
        }
        field(50010; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            TableRelation = IF ("Approval Type" = FILTER("Specific Approver" | "Direct Approver")) "User Setup"."User ID"
            ELSE
            IF ("Approval Type" = filter("Workflow User Group" | "Sales Pers./Purchaser")) "Office/Group".Code;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                AddAppr: Record "Additional Approver";
                ApprTemplate: Record "Approval Template";
                Temp: Record "User Setup";
            begin
                AddAppr.SetRange("Approval Code", "Approval Code");
                AddAppr.SetRange("Approval Type", "Approval Type");
                AddAppr.SetRange("Document Type", "Document Type");
                AddAppr.SetRange("Limit Type", "Limit Type");
                if "Approver ID" <> '' then begin
                    AddAppr.SetRange("Approver ID", "Approver ID");
                    if AddAppr.FindFirst then
                        Error(StrSubstNo(Text001, AddAppr."Approver ID"));
                end else begin
                    AddAppr.SetFilter("Approver ID", '<>%1&<>%2', '', xRec."Approver ID");
                    if not AddAppr.FindFirst then
                        if ApprTemplate.Get("Approval Code", "Approval Type", "Document Type", "Limit Type") then
                            if ((ApprTemplate."Approval Type" = ApprTemplate."Approval Type"::"Specific Approver") or
                                (ApprTemplate."Limit Type" = ApprTemplate."Limit Type"::"Credit Limits")) and ApprTemplate.Enabled
                            then
                                if Confirm(StrSubstNo(Text002, AddAppr.TableCaption)) then begin
                                    ApprTemplate.Validate(Enabled, false);
                                    ApprTemplate.Modify;
                                end else
                                    Error('');
                end;
                Temp.Get(UserId);
                Temp.TestField("Approver ID");
                if Temp."Approver ID" = UserId then Error('Direct approval not supported.Kindly contact your administrator for assistance');
            end;
        }
        field(50011; "Approval Type"; Enum "ApprovalType")
        {
            Caption = 'Approval Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Document Type"; Enum "CustomApprovalEntriesDocType")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Limit Type"; Enum "LimitType")
        {
            Caption = 'Limit Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50015; "Minimum Amount"; Decimal)
        {
            Caption = 'Minimum Amount';
            DataClassification = CustomerContent;
        }
        field(50016; "Maximum Amount"; Decimal)
        {
            Caption = 'Maximum Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Approver ID", "Approval Code", "Approval Type", "Document Type", "Limit Type", "Sequence No.")
        {
            Clustered = true;
        }
        key("Key2"; "Sequence No.")
        {

        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Approver ID %1 is already an additional approver on this template.';
        Text002: Label 'The approval template will be disabled because no %1 are available.\Do you want to continue?';
}




