table 50463 "Guarantors Substitution"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();

            end;
        }
        field(50010; "Loan Account No."; Code[20])
        {
            TableRelation = "Credit Account";
            Caption = 'Loan Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "Name"; Text[50])
        {
            Editable = false;
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Account Status"; Enum "MemberStatus")
        {
            Editable = false;
            Caption = 'Account Status';
            DataClassification = CustomerContent;
        }
        field(50013; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50014; "Current Savings"; Decimal)
        {
            Editable = false;
            Caption = 'Current Savings';
            DataClassification = CustomerContent;
        }
        field(50015; "FOSA Account"; Code[20])
        {
            Editable = false;
            Enabled = false;
            Caption = 'FOSA Account';
            DataClassification = CustomerContent;
        }
        field(50016; "Business Loan No."; Code[20])
        {
            Editable = false;
            Enabled = false;
            Caption = 'Business Loan No.';
            DataClassification = CustomerContent;
        }
        field(50017; "Business Loan Shares"; Decimal)
        {
            Editable = false;
            Caption = 'Business Loan Shares';
            DataClassification = CustomerContent;
        }
        field(50018; "Posted By"; Code[50])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50019; "Captured By"; Code[50])
        {
            Editable = false;
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50020; "Responsibility Centre"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50021; "Activity Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Caption = 'Activity Code';
            DataClassification = CustomerContent;
        }
        field(50022; "Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50023; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50024; "Date"; Date)
        {
            Editable = false;
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(50025; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50026; "ID/Passport"; Code[10])
        {
            Caption = 'ID/Passport';
            DataClassification = CustomerContent;
        }
        field(50027; "Loan No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Substitution Type" = const("Guarantor Substitution")) Loans."No." where("Outstanding Balance" = filter(> 0))
            else
            if ("Substitution Type" = const("Signatory Substitution")) "Account Signatories" where(Substituted = const(false))
            else
            if ("Substitution Type" = const("Kin Substitution")) "Account Kins" where(Replaced = const(false));
        
            trigger OnValidate()
            var
                PLoan: Record Loans;
                Acc: Record "Account Credit";
                GuarantorPosted: Record "Guarantor & Security Posted";
                RegMngt: Codeunit "Register Management";
                ErrorOnMissingGuarantorsTxt: Label 'This loan does not have any guarantor/security attached to it';
            begin

                GuarantorPosted.Reset();
                GuarantorPosted.SetRange("Loan No.", Rec."Loan No.");
                GuarantorPosted.SetFilter("Security Type", '%1 | %2', GuarantorPosted."Security Type"::Guarantor, GuarantorPosted."Security Type"::Lien);
                if not GuarantorPosted.Find('-') then
                    Error(ErrorOnMissingGuarantorsTxt);

                if PLoan.Get("Loan No.") then
                    "Loan Account No." := PLoan."Loan Account";
                Name := PLoan."Account Name";

                Acc.Reset();
                Acc.SetRange("Member No.", PLoan."Account No.");
                Acc.SetRange("Account Category", Acc."Account Category"::"Shares Deposit");
                if Acc.FindFirst() then
                    Acc.CalcFields("Balance (LCY)");
                "Account Status" := Acc.Status;
                "Current Savings" := Acc."Balance (LCY)";

                "Guarantors Name" := '';
                "Amount Guaranteed" := 0;

            end;
        }
        field(50028; "Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50029; "Amount Guaranteed"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Amount Guaranteed';
        
            trigger OnValidate()
            var
                agreement: Record "Guarantor & Security Posted";
                acmgt: Record "Account Credit";
            begin
                if "Application Type" = "Application Type"::"Update Amount Guaranteed" then begin
                    agreement.SetRange("Account No.", "Guarantors To Be Substituted");
                    agreement.SetRange(Substituted, false);
                    if agreement.FindFirst() then begin
                        acmgt.SetRange("No.", agreement."Account No.");
                        if acmgt.FindFirst() then
                            acmgt.CalcFields("Balance (LCY)");
                        if "Amount Guaranteed" > acmgt."Balance (LCY)" then
                            Error('Amount guaranteed cannot be more than shares balance of %1', acmgt."Balance (LCY)");
                    end else begin
                        Error('Account not found');
                    end;
                end
            end;
        }
        field(50030; "Guarantors To Be Substituted"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Application Type" = filter(Substitution)) "Guarantor & Security Posted"."Account No." where("Loan No." = field("Loan No."), Substituted = const(false)) else
            if ("Application Type" = filter("New Entrant")) "Account Credit" where("Account Category" = filter("Shares Deposit"), "Balance (LCY)" = filter(> 0));
            Caption = 'Account to Attach/Dettach';
        
            trigger OnValidate()
            Var
                LoanG: Record "Loan Guarantors Sub";
                Agreement: Record "Guarantor & Security Posted";
                PLoan: Record Loans;
                Acc: Record "Account Credit";
                GuarantorPosted: Record "Guarantor & Security Posted";
                RegMngt: Codeunit "Register Management";
                ErrorOnMissingGuarantorsTxt: Label 'This loan does not have any guarantor/security attached to it';
            begin
                
                Agreement.Reset();
                Agreement.SetRange("Loan No.", "Loan No.");
                Agreement.SetRange("Account No.", "Guarantors To Be Substituted");
                if Agreement.Find('-') then
                    "Guarantors Name" := Agreement.Name;
                "Amount Guaranteed" := Agreement."Amount Guaranteed";
                "Security Type" := Agreement."Security Type";
                TestField("Loan No.");
                if "Guarantors To Be Substituted" <> '' then begin

                    case "Application Type" of
                        "Application Type"::Substitution:
                            begin
                                RegMngt.PassAgreement("Loan No.", "No.", "Guarantors To Be Substituted", 0);
                            end;
                        "Application Type"::"New Entrant":
                            begin
                                RegMngt.PassAgreement("Loan No.", "No.", "Guarantors To Be Substituted", 1);
                            end;
                    end;
                end;
            end;
        }
        field(50031; "Guarantors Name"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Guarantors Name';
        }
        field(50032; "Distributed Amount"; Decimal)
        {
            CalcFormula = Sum("Loan Guarantors Sub"."Amount Guaranteed" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Distributed Amount';
        }
        field(50033; "Remaining Liability"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Remaining Liability';
        }
        field(50034; "Substitution Type"; Option)
        {
            OptionCaption = ' ,Guarantor Substitution,Signatory Substitution,Kin Substitution';
            OptionMembers = " ","Guarantor Substitution","Signatory Substitution","Kin Substitution";
        }
        field(50035; "Post As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Post as User,Post Automatically';
            OptionMembers = " ","Create as User","Post Automatically";
            Caption = 'Post As';
        }
        field(50036; "Send Notification"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,SMS,Email,SMS+Email';
            OptionMembers = " ","SMS","Email","SMS+E-Mail";
        }
        field(50037; "Application Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Substitution","New Entrant","Update Amount Guaranteed";
        }
        field(30; "Security Type"; Option)
        {
            OptionCaption = 'Guarantor,Collateral,Lien';
            OptionMembers = Guarantor,Collateral,Lien;
            Caption = 'Security Type';
            DataClassification = CustomerContent;
        }
        field(31; "Available Shares"; Decimal)
        {
            Editable = false;
            Caption = 'Available Shares';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin

            CreditNosSeries.Get;
            CreditNosSeries.TestField(CreditNosSeries."Guarantors Substitution");
            "No. Series" := CreditNosSeries."Guarantors Substitution";
            if NoSeriesMgt.AreRelated(CreditNosSeries."Guarantors Substitution", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;
        "Captured By" := UserId;
        Date := Today;
        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        UserSetup.TestField("Responsibility Centre");
        "Activity Code" := UserSetup."Global Dimension 1 Code";
        "Branch Code" := UserSetup."Global Dimension 2 Code";
        "Responsibility Centre" := UserSetup."Responsibility Centre";
    end;

    procedure CheckMinRequiredInfo()
    begin
        TestField("Post As");
        TestField("Substitution Type");
        TestField("Loan No.");
        TestField("Guarantors To Be Substituted");
        TestField(Posted, false);
    end;

    procedure PostApprovalRequest(ApprovalRequest: Integer)
    var
        ApprovalMngt: Codeunit "Approval Mgmt.";
    begin
        case ApprovalRequest of
            0:
                ApprovalMngt.OnSendDocSubstitutionRegtRequest(Rec);
            1:
                ApprovalMngt.OnCancelDocSubstitutionRegtApprovalRequest(Rec, true, true);
            2:
                ApprovalMngt.OpenDocSubstitutionRegtApprovalRequest(Rec, true, true)
        end
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Dividend Simulation Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                CreditNosSeries.Get();
                NoSeriesMgt.TestManual(CreditNosSeries."Guarantors Substitution");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Guarantors Substitution"; xRecRef: Record "Guarantors Substitution"; var IsHandled: Boolean)
    begin
    end;

    var
        CreditNosSeries: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
}




