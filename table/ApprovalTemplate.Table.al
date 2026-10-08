table 50546 "Approval Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50010; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
            TableRelation = "Approval Code".Code;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Enabled, false);
                ApprCode.Get("Approval Code");
                ApprCode.TestField("Linked To Table No.");
                "Table ID" := ApprCode."Linked To Table No.";
            end;
        }
        field(50011; "Approval Type"; Enum "ApprovalType")
        {
            Caption = 'Approval Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(50012; "Document Type"; Enum "CustomApprovalEntriesDocType")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(50013; "Limit Type"; Enum "LimitType")
        {
            Caption = 'Limit Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(50014; "Additional Approvers"; Boolean)
        {
            CalcFormula = Exist("Additional Approver" WHERE("Approval Code" = FIELD("Approval Code"),
                                                             "Approval Type" = FIELD("Approval Type"),
                                                             "Document Type" = FIELD("Document Type"),
                                                             "Limit Type" = FIELD("Limit Type"),
                                                             "Approver ID" = FILTER(<> '')));
            Caption = 'Additional Approvers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Enabled"; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Salesheader: Record "Sales Header";
                PurchaseHeader: Record "Purchase Header";
                ApprovalEntry: Record "Approval Entry";
                TempApprovalTemplate: Record "Approval Template";
            begin
                if (Enabled = false) and (xRec.Enabled = true) then begin
                    TempApprovalTemplate.SetRange("Approval Code", "Approval Code");
                    TempApprovalTemplate.SetRange("Document Type", "Document Type");
                    if not TempApprovalTemplate.FindFirst then begin
                        case "Table ID" of
                            DATABASE::"Sales Header":
                                begin
                                    Salesheader.SetCurrentKey("Document Type", Status);
                                    Salesheader.SetRange("Document Type", "Document Type");
                                    Salesheader.SetRange(Status, Salesheader.Status::"Pending Approval");
                                    if Salesheader.FindFirst then begin
                                        if Confirm(Text006) then begin
                                            ApprovalEntry.SetRange("Table ID", DATABASE::"Sales Header");
                                            ApprovalEntry.SetRange("Document Type", Rec."Document Type");
                                            ApprovalEntry.SetFilter(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            if ApprovalEntry.FindFirst then
                                                ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
                                        end;
                                        Salesheader.ModifyAll(Status, Salesheader.Status::Open);
                                    end;
                                end;
                            DATABASE::"Purchase Header":
                                begin
                                    PurchaseHeader.SetCurrentKey("Document Type", Status);
                                    PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                                    PurchaseHeader.SetRange(Status, PurchaseHeader.Status::"Pending Approval");
                                    if PurchaseHeader.FindFirst then begin
                                        if Confirm(Text006) then begin
                                            ApprovalEntry.SetRange("Table ID", DATABASE::"Purchase Header");
                                            ApprovalEntry.SetRange("Document Type", Rec."Document Type");
                                            ApprovalEntry.SetFilter(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            if ApprovalEntry.FindFirst then
                                                ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
                                        end;
                                        PurchaseHeader.ModifyAll(Status, Salesheader.Status::Open);
                                    end;
                                end;
                        end;
                    end;
                end;

                if "Approval Type" = "Approval Type"::"Specific Approver" then begin
                    CalcFields("Additional Approvers");
                    if not "Additional Approvers" and Enabled then
                        Error(StrSubstNo(Text005, FieldCaption("Approval Type")));
                end;
                if ("Approval Type" <> "Approval Type"::"Specific Approver") and ("Limit Type" = "Limit Type"::"Credit Limits") then begin
                    CalcFields("Additional Approvers");
                    if not "Additional Approvers" and Enabled then
                        Error(StrSubstNo(Text007, FieldCaption("Approval Type"), Format("Approval Type"),
                            FieldCaption("Limit Type")));
                end;
            end;
        }
        field(50016; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center".Code;
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50017; "Transaction Type"; Option)
        {
            OptionCaption = 'Loans,Refunds,Branch,AccountsBosa,AccountsFosa,Withdrawal,Activation';
            OptionMembers = "Loans","Refunds","Branch","AccountsBosa","AccountsFosa","Withdrawal","Activation";
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Use Responsibility Centre"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50019; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Product Factory";
        }

    }

    keys
    {
        key("Key1"; "Table ID", "Document Type", "Approval Code", "Responsibility Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ApprCode: Record "Approval Code";
        Text001: Label '%1 is not a valid limit type for table %2.';
        Text002: Label '%1 is only valid for table %2.';
        Text004: Label '%1 is only valid when document type is Quote and Table ID is %2.';
        Text005: Label 'Additional Approvers must be inserted if %1 is blank.';
        Text006: Label 'Do you want to cancel all outstanding approvals? ';
        Text007: Label 'Additional Approvers must be inserted if %1 is %2 and %3 is Credit Limit.';


    procedure TestValidation()
    var
        AppSetup: Record "Approval Setup";
    begin
        AppSetup.Get;
        if ("Table ID" = DATABASE::"Purchase Header") and
           ("Limit Type" = "Limit Type"::"Credit Limits") then
            Error(StrSubstNo(Text001, Format("Limit Type"), DATABASE::"Purchase Header"));

        if ("Table ID" <> DATABASE::"Purchase Header") and
           ("Limit Type" = "Limit Type"::"Request Limits") then
            Error(StrSubstNo(Text002, Format("Limit Type"), DATABASE::"Purchase Header"))
        else begin
            if ("Table ID" = DATABASE::"Purchase Header") and
               ("Limit Type" = "Limit Type"::"Request Limits") and
               ("Document Type" <> "Document Type"::CardLink) then
                Error(StrSubstNo(Text004, Format("Limit Type"), "Table ID"));
        end;
    end;


    procedure RenameAddApprovers(Template: Record "Approval Template"; xTemplate: Record "Approval Template")
    var
        AddApprovers: Record "Additional Approver";
        RenamedAddApprovers: Record "Additional Approver";
    begin
        AddApprovers.SetRange("Approval Code", xTemplate."Approval Code");
        AddApprovers.SetRange("Approval Type", xTemplate."Approval Type");
        AddApprovers.SetRange("Document Type", xTemplate."Document Type");
        AddApprovers.SetRange("Limit Type", xTemplate."Limit Type");
        if AddApprovers.Find('-') then begin
            repeat
                RenamedAddApprovers := AddApprovers;
                RenamedAddApprovers."Approval Code" := Template."Approval Code";
                RenamedAddApprovers."Approval Type" := Template."Approval Type";
                RenamedAddApprovers."Document Type" := Template."Document Type";
                RenamedAddApprovers."Limit Type" := Template."Limit Type";
                AddApprovers.Delete;
                RenamedAddApprovers.Insert;
            until AddApprovers.Next = 0;
        end;
    end;
}




