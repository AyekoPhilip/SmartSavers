table 50461 "Member withdrawal Notice"
{
    DrillDownPageID = "Member withdrawal Notice List";
    LookupPageID = "Member withdrawal Notice List";
    DataClassification = CustomerContent;


    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Member No."; Code[20])
        {
            TableRelation = Member where(Status = filter(Active | New | Dormant));
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                LoanAgreement: Record "Guarantor & Security Posted";
                CreditAc: Record "Account Credit";
                RegMngt: Codeunit "Register Management";
                ErrorOnExcessLiability: Label 'Liabilities more than available balance to allow for member exit';
                ErrorOnNonsubCust: Label 'This member account is still attached as a guarantor. Kindly substitute before you continue';
            begin
                if Members.Get("Member No.") then begin

                    CreditAc.Reset();
                    CreditAc.SetRange("Member No.", Members."No.");
                    CreditAc.SetRange("Account Category", CreditAc."Account Category"::"Shares Deposit");
                    if CreditAc.FindFirst() then begin

                        if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin
                            if RegMngt.getguarantorBalance(CreditAc."No.") > 0 then
                                Error(ErrorOnNonsubCust);
                            if RegMngt.getCustLoanBalance(0, CreditAc."Member No.", 0) > RegMngt.GetOperationAccBalanceTxt(CreditAc."Account Category", CreditAc."Member No.", 4) then
                                Error(ErrorOnExcessLiability);



                        END;
                    end;

                    Name := Members.Name;
                    "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                    Email := Members."E-Mail";
                    "Total Savings" := RegMngt.GetOperationAccBalanceTxt(CreditAc."Account Category", CreditAc."Member No.", 4);
                    "Total Liabilities" := RegMngt.getCustLoanBalance(0, CreditAc."Member No.", 0)
                end
            end;
        }
        field(50011; "Reason for withdrawal"; Code[20])
        {
            Caption = 'Reason for withdrawal';
            DataClassification = CustomerContent;
            TableRelation = "Segment/County/Dividend/Signat".Code where(Type = const(WReason));
        
            trigger OnValidate()
            begin
                SegmentRec.Reset();
                SegmentRec.SetRange(Type, SegmentRec.Type::WReason);
                SegmentRec.SetRange(Code, "Reason for withdrawal");
                if SegmentRec.FindFirst() then
                    "Description For Withdrawal" := SegmentRec.Description
            end;
        }
        field(50012; "Withdrawal Notice Date"; Date)
        {
            Caption = 'Withdrawal Notice Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Withdrawal Notice Date" > today then
                    Error('Date must be less than today');

                GeneralSetUp.Get();
                GeneralSetUp.TestField(GeneralSetUp."Withdrawal Notice period");
                "Maturity Date" := CalcDate(Format(GeneralSetUp."Withdrawal Notice period"), "Withdrawal Notice Date");
            end;
        }
        field(50013; "Maturity Date"; Date)
        {
            Caption = 'Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Entered By"; Code[50])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50015; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50016; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50017; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
            begin
                UpdateMemberStatus();
            end;
        }
        field(50018; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50019; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50020; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50021; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50022; "Paid"; Boolean)
        {
            Caption = 'Paid';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50023; "Expired"; Boolean)
        {
            Caption = 'Expired';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50024; "Responsibility Center"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
        }
        field(50025; "Email"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            Editable = false;
        }

        field(50026; "Description For Withdrawal"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            Editable = false;
        }
        field(50027; "Document Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Membership Closure","Account Closure";
            OptionCaption = ' ,Membership Withdrawal,Account Closure';
        
            trigger OnValidate()
            var
                CreditAc: Record "Account Credit";
                RegMngt: Codeunit "Register Management";
            begin
                TestField("Member No.");
                case "Document Type" of
                    "Document Type"::"Account Closure":
                        begin
                            "Closure Type" := "Closure Type"::"Close Specific Account";
                        end;
                    "Document Type"::"Membership Closure":
                        begin

                            "Closure Type" := "Closure Type"::" ";
                            CreditAc.SetRange("Member No.", "Member No.");
                            CreditAc.SetRange("Account Category", CreditAc."Account Category"::"Shares Deposit");
                            if CreditAc.FindFirst() then
                                "Account No." := CreditAc."No.";
                        end;
                end;
            end;
        }
        field(50028; "Total Liabilities"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50029; "Total Savings"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50030; "Closure Type"; Enum "AccClosureType")
        {
            Caption = 'Closure Type';
            DataClassification = CustomerContent;
            ValuesAllowed = 0, 1, 2, 4;
        
            trigger OnValidate()
            begin
                case "Closure Type" of
                    "Closure Type"::"Withdrawal - Normal",
                    "Closure Type"::"Withdrawal - Death":
                        begin
                            TestField("Document Type", "Document Type"::"Membership Closure");
                        end;
                end;
            end;
        }
        field(50031; "Date of Death"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50032; "Application Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Recovery from Deposit","Recovery from Fosa";
        }
        field(50033; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Account Dimension" = const(Banking)) "Account Banking"."No." where(Blocked = const(" "), "Member No." = field("Member No."),
            Status = filter(Active | New | Dormant | Defaulter), "Account Category" = filter(Junior | "Money Market" | "Women Savings" | "Specialty Savings" | "Islamic Banking")) else
            if ("Account Dimension" = filter(Credit)) "Account Credit"."No." where(Blocked = const(" "), "Member No." = field("Member No."), "Account Category" = filter("Benevolent Fund"), Status = filter(Active | New | Dormant | Defaulter));
        
            trigger OnValidate()
            var
                FosaAc: Record "Account Banking";
            begin
                Rec.TestField("Member No.");
                if "Account Dimension" = "Account Dimension"::Banking then begin
                    if DocMngt.CheckLienAccLoan("Account No.") then
                        Error(ErrorOnExistLoanApp);
                end;
            end;
        }
        field(50034; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
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

    trigger OnDelete()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Approved then
            Error(Txt00001);
    end;

    trigger OnInsert()
    var
        Temp: Record "User Setup";
    begin
        if "No." = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Withdrawal Notice");
            "No. Series" := NoSetup."Withdrawal Notice";
            if NoSeriesMgt.AreRelated(NoSetup."Withdrawal Notice", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Entered By" := UserId;

        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Center" := Temp."Responsibility Centre";

    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Member withdrawal Notice";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                NoSeriesMgt.TestManual(NoSetup."Withdrawal Notice");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Member withdrawal Notice"; xRecRef: Record "Member withdrawal Notice"; var IsHandled: Boolean)
    begin
    end;

    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Members: Record Member;
        PFact: Record "Product Factory";
        GeneralSetUp: Record "General Set-Up";
        Txt00001: Label 'You cannot delete approved record';
        SegmentRec: Record "Segment/County/Dividend/Signat";
        Loans: Record Loans;
        Accbanking: Record "Account Banking";
        CredAcc: Record "Account Credit";
        Cust: Record Member;
        DocMngt: Codeunit "Doc-PostMgt";
        ErrorOnExistLoanApp: Label 'Member has an exiting Loan attached to this account';

    procedure UpdateMemberStatus()
    begin
        case "Approval Status" of

            "Approval Status"::Approved:
                begin
                    if "Closure Type" = "Closure Type"::"Withdrawal - Death" then begin

                        Cust.Reset();
                        Cust.SetRange("No.", "Member No.");
                        if Cust.Find('-') then begin
                            Cust.ModifyAll(Status, Cust.Status::Deceased);
                        end;

                        Loans.Reset();
                        Loans.SetRange("Account No.", "Member No.");
                        Loans.SetFilter("Outstanding Balance", '>0');
                        if Loans.Find('-') then begin
                            Loans.ModifyAll("Interest Options", Loans."Interest Options"::"Suspend Interest");
                        end;

                        Accbanking.Reset();
                        Accbanking.SetRange("Member No.", "Member No.");
                        if Accbanking.Find() then begin
                            Accbanking.ModifyAll(Status, Accbanking.Status::Deceased);
                        end;

                        CredAcc.Reset();
                        CredAcc.SetRange("Member No.", "Member No.");
                        if CredAcc.Find('-') then begin
                            CredAcc.ModifyAll(Status, CredAcc.Status::Deceased);
                        end;
                    end;

                    if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin

                        Cust.Reset();
                        Cust.SetRange("No.", "Member No.");
                        if Cust.Find('-') then begin
                            Cust.ModifyAll(Status, Cust.Status::"Withdrawal Application");
                        end;

                        Loans.Reset();
                        Loans.SetRange("Account No.", "Member No.");
                        Loans.SetFilter("Outstanding Balance", '>0');
                        if Loans.Find('-') then begin
                            Loans.ModifyAll("Interest Options", Loans."Interest Options"::"Suspend Interest");
                        end;

                        Accbanking.Reset();
                        Accbanking.SetRange("Member No.", "Member No.");
                        if Accbanking.Find() then begin
                            Accbanking.ModifyAll(Status, Accbanking.Status::"Withdrawal Application");
                        end;

                        CredAcc.Reset();
                        CredAcc.SetRange("Member No.", "Member No.");
                        if CredAcc.Find('-') then begin
                            CredAcc.ModifyAll(Status, CredAcc.Status::"Withdrawal Application");
                        end;
                    end;

                end;
            "Approval Status"::Open,
            "Approval Status"::"Pending Approval":
                begin
                    if "Closure Type" = "Closure Type"::"Withdrawal - Death" then begin
                        Cust.Reset();
                        Cust.SetRange("No.", "Member No.");
                        if Cust.Find('-') then begin
                            Cust.ModifyAll(Status, Cust.Status::"Withdrawal Application");
                        end;

                        Loans.Reset();
                        Loans.SetRange("Account No.", "Member No.");
                        Loans.SetFilter("Outstanding Balance", '>0');
                        if Loans.Find('-') then begin
                            Loans.ModifyAll("Interest Options", Loans."Interest Options"::"Charge Interest");
                        end;

                        Accbanking.Reset();
                        Accbanking.SetRange("Member No.", "Member No.");
                        if Accbanking.Find() then begin
                            Accbanking.ModifyAll(Status, Accbanking.Status::"Withdrawal Application");
                        end;

                        CredAcc.Reset();
                        CredAcc.SetRange("Member No.", "Member No.");
                        if CredAcc.Find('-') then begin
                            CredAcc.ModifyAll(Status, CredAcc.Status::"Withdrawal Application");
                        end;

                    end;

                    if "Closure Type" = "Closure Type"::"Withdrawal - Normal" then begin

                        Cust.Reset();
                        Cust.SetRange("No.", "Member No.");
                        if Cust.Find('-') then begin
                            Cust.ModifyAll(Status, Cust.Status::"Withdrawal Application");
                        end;

                        Loans.Reset();
                        Loans.SetRange("Account No.", "Member No.");
                        Loans.SetFilter("Outstanding Balance", '>0');
                        if Loans.Find('-') then begin
                            Loans.ModifyAll("Interest Options", Loans."Interest Options"::"Charge Interest");
                        end;

                        Accbanking.Reset();
                        Accbanking.SetRange("Member No.", "Member No.");
                        if Accbanking.Find() then begin
                            Accbanking.ModifyAll(Status, Accbanking.Status::"Withdrawal Application");
                        end;

                        CredAcc.Reset();
                        CredAcc.SetRange("Member No.", "Member No.");
                        if CredAcc.Find('-') then begin
                            CredAcc.ModifyAll(Status, CredAcc.Status::"Withdrawal Application");
                        end;
                    end;

                end;
        end;

    end;

    procedure CheckMinRequirement()
    begin
        case "Closure Type" of
            "Closure Type"::"Withdrawal - Death":
                begin
                    KinDetail.Reset();
                    KinDetail.SetRange("Application No.", "No.");
                    KinDetail.SetRange("Account No", "Member No.");
                    if not KinDetail.Find('-') then begin
                        Error('Next of Kin Details not available');
                    end;

                    KinDetail.Reset();
                    KinDetail.SetRange("Application No.", "No.");
                    KinDetail.SetRange("Account No", "Member No.");
                    if KinDetail.FindSet() then begin
                        repeat
                            KinDetail.TestField(Name);
                            KinDetail.TestField("ID No.");
                            KinDetail.TestField(Relationship);
                            KinDetail.TestField(Allocation);
                            KinDetail.TestField("BBF Entitlement Code");
                        until KinDetail.Next() = 0;
                    end;

                end;
        end;

    end;

    var
        KinDetail: Record "Next of KIN";
        BBFEntitlement: Record "BBF Entitlement";


}




