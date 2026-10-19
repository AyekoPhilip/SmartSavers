table 50573 "Mc Acc. Changes"
{
    Caption = 'Mc Acc. Changes';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(50010; "Name"; Text[80])
        {
            Caption = 'Name';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                NameBreakdown
            end;
        }
        field(50011; "Member No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Member."No." where(Status = filter(<> Deceased | Withdrawn | "Withdrawal Application"));
            Caption = 'Member No.';
        
            trigger OnValidate()
            var
                MngtRegt: Codeunit "Registry Mngt.";
                Cust: Record Member;
            begin
                Rec.TestField("Changes Type");
                getCustomerDetails();
            end;
        }

        field(50012; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50013; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }

        field(50014; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50015; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
        }

        field(50016; "Status"; Enum "MemberStatus")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            Editable = false;
        }
        field(50017; "Employer Code"; Code[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Employer Code';
        }

        field(50018; "Resons for Status Change"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Resons for Status Change';
        }
        field(50019; "Payroll/Staff No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll/Staff No.';
        }

        field(50020; "First Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'First Name';
            Editable = false;
        }

        field(50021; "Second Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Second Name';
            Editable = false;
        }
        field(50022; "Last Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Last Name';
            Editable = false;
        }

        field(50023; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }

        field(50024; "Source"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Navision,CRM,Web';
            OptionMembers = " ","Navision","CRM","Web";
            Editable = false;
            Caption = 'Source';
        }
        field(50025; "Pay Point"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Pay Point';
        
            trigger OnValidate()
            var
                Cusr: Record Customer;
            begin
            end;
        }
        field(50026; "Application Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application Date';
        }
        field(50027; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Approval Status';
        }

        field(50028; "Changes Type"; Enum "AccountChangesTypes")
        {
            DataClassification = CustomerContent;
            Caption = 'Changes Type';
        }
        field(50029; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Posted';
        }
        field(50030; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50031; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionMembers = "Member Change","Account Activation","Kin Signatories","Card Link";
        }
        field(50032; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50033; "Member Category"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Member Category";
            Caption = 'Member Category';
        }
        field(50034; "Allow Min. Banding"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow Minimum Banding';
        }
        field(50035; "Loan No."; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Loans where("Outstanding Balance" = filter(> 0), "Account No." = field("Member No."));
        }
        field(50036; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
            Editable = false;
        }
        field(50037; "Account Type"; Enum "AccountTypesExtended")
        {
            Caption = 'Account Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50038; "Account No."; Code[100])
        {
            TableRelation = if ("Account Type" = const(Savings), "Changes Type" = filter("Account Activation"), "Member No." = filter(<> ''))
            "Account Banking" where(Blocked = CONST(" "),
                                "Account Category" = filter(Savings | Junior),
                                "Member No." = field("Member No."),
                                Status = filter(Active | Defaulter | New | Dormant)) else
            if ("Account Type" = const(Savings), "Changes Type" = filter("Account Activation"), "Member No." = filter(< ''))
            "Account Banking" where(Blocked = CONST(" "), "Account Category" = filter("Money Market"),
                                Status = filter(Active | Defaulter | New | Dormant));
            DataClassification = CustomerContent;
        }


    }
    keys
    {
        key("PK"; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Member Reactivation Nos.");
            if NoSeriesMgt.AreRelated(SeriesSetup."Member Reactivation Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")
        end;

        "Application Date" := CurrentDateTime;
        "Created By" := UserId;

        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Center" := Temp."Responsibility Centre";
        "Last Date Modified" := Today
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today
    end;

    var
        SeriesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Temp: Record "User Setup";
        RegMngt: Codeunit "Register Management";
        Varvariant: Variant;
        CustRec: Record Member;
        LoanRec: Record Loans;
        BosaAcc: Record "Account Credit";

    local procedure NameBreakdown()
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;
    begin
        TempName := Name;

        while StrPos(TempName, ' ') > 0 do begin
            if StrPos(TempName, ' ') > 1 then begin
                i := i + 1;
                NamePart[i] := CopyStr(TempName, 1, StrPos(TempName, ' ') - 1);
            end;
            TempName := CopyStr(TempName, StrPos(TempName, ' ') + 1);
        end;
        i := i + 1;
        NamePart[i] := CopyStr(TempName, 1, MaxStrLen(NamePart[i]));
        NoOfParts := i;

        "First Name" := '';
        "Second Name" := '';
        "Last Name" := '';
        for i := 1 to NoOfParts do
            if (i = NoOfParts) and (NoOfParts > 1) then
                "Last Name" := CopyStr(NamePart[i], 1, MaxStrLen("Last Name"))
            else
                if (i = NoOfParts - 1) and (NoOfParts > 2) then
                    "Second Name" := CopyStr(NamePart[i], 1, MaxStrLen("Second Name"))
                else begin
                    FirstName250 := DelChr("First Name" + ' ' + NamePart[i], '<', ' ');
                    "First Name" := CopyStr(FirstName250, 1, MaxStrLen("First Name"));
                end;
    end;

    procedure getCustomerDetails()
    begin
        if CustRec.Get("Member No.") then begin
            Name := CustRec.Name;
            "Employer Code" := CustRec."Employer Code";
            "Member Category" := CustRec."Member Category";
            "Payroll/Staff No." := CustRec."Payroll/Staff No.";
            "Pay Point" := CustRec."Pay Point";
            Status := CustRec.Status;
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRef: Record "Mc Acc. Changes";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRef.Get(Rec."No.") then begin
                SeriesSetup.Get();
                NoSeriesMgt.TestManual(SeriesSetup."Member Reactivation Nos.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Mc Acc. Changes"; xRecRef: Record "Mc Acc. Changes"; var IsHandled: Boolean)
    begin
    end;

    procedure PostCustomerDetails()
    var
        Account: Record "Account Banking";
    begin
        if CustRec.Get("Member No.") then begin
            case "Account Dimension" of
                "Account Dimension"::Banking:
                    begin

                        case "Changes Type" of
                            "Changes Type"::"Mark As Defaulter":
                                begin
                                    if CustRec.Get("Member No.") then begin
                                        CustRec."Mobile Status" := CustRec."Mobile Status"::Defaulter;
                                    end;
                                end;
                            "Changes Type"::"Unmark As Defaulter":
                                begin
                                    if CustRec.Get("Member No.") then begin
                                        CustRec."Mobile Status" := CustRec."Mobile Status"::Active;
                                    end;
                                end;
                            "Changes Type"::"Account Activation":
                                begin
                                    Account.Reset();
                                    Account.SetRange("No.", "Account No.");
                                    if Account.FindFirst() then begin
                                        Account.Status := Account.Status::Active;
                                        Account.Modify(true)
                                    end;
                                end;
                        end;
                        CustRec.Modify(true);
                    end;
                "Account Dimension"::Credit:
                    begin

                        case "Changes Type" of
                            "Changes Type"::"Mark As Defaulter":
                                begin
                                    if CustRec.Get("Member No.") then begin
                                        CustRec."Loan Status" := CustRec."Loan Status"::Defaulter;
                                        CustRec.Modify(true);
                                    end;
                                end;
                            "Changes Type"::"Mark As Guarantor":
                                begin
                                    BosaAcc.Reset();
                                    BosaAcc.SetRange("Member No.", "Member No.");
                                    BosaAcc.SetRange("Account Category", BosaAcc."Account Category"::"Shares Deposit");
                                    if BosaAcc.FindFirst() then begin
                                        BosaAcc."Can Guarantee Loan" := true;
                                        BosaAcc.Modify(true)
                                    end;

                                end;
                            "Changes Type"::"Non-Guarantor":
                                begin
                                    BosaAcc.Reset();
                                    BosaAcc.SetRange("Member No.", "Member No.");
                                    BosaAcc.SetRange("Account Category", BosaAcc."Account Category"::"Shares Deposit");
                                    if BosaAcc.FindFirst() then begin
                                        BosaAcc."Can Guarantee Loan" := false;
                                        BosaAcc.Modify(true)
                                    end;
                                end;
                            "Changes Type"::"Suspend Interest":
                                begin
                                    TestField("Loan No.");
                                    LoanRec.SetRange("No.", "Loan No.");
                                    if LoanRec.FindFirst() then begin
                                        LoanRec."Interest Options" := LoanRec."Interest Options"::"Suspend Interest";
                                        LoanRec.Modify(true)
                                    end;

                                end;

                            "Changes Type"::"Account Activation":
                                begin
                                    if CustRec.Get("Member No.") then begin
                                        CustRec.TestField("Loan Status", CustRec."Loan Status"::Defaulter);
                                        CustRec."Loan Status" := CustRec."Loan Status"::Active;
                                        CustRec.Modify(true);
                                    end;
                                end;
                            "Changes Type"::"Membership Details":
                                begin
                                    if CustRec.Get("Member No.") then begin
                                        if CustRec."Employer Code" <> "Employer Code" then
                                            CustRec."Employer Code" := "Employer Code";
                                        if CustRec."Payroll/Staff No." <> "Payroll/Staff No." then
                                            CustRec."Payroll/Staff No." := "Payroll/Staff No.";
                                        if CustRec."Member Category" <> "Member Category" then
                                            CustRec."Member Category" := "Member Category";
                                        if CustRec."Pay Point" <> "Pay Point" then
                                            CustRec."Pay Point" := "Pay Point";
                                        if CustRec."Allow Min. Banding" <> "Allow Min. Banding" then
                                            CustRec."Allow Min. Banding" := "Allow Min. Banding";
                                        CustRec.Modify(true);
                                    end;
                                end;
                        end;
                    end;
            end;

            "Date Posted" := CurrentDateTime;
            "Posted By" := UserId;
            "Approval Status" := "Approval Status"::Posted;
            Modify(true);
            Message('Operation complete');
        end;

    end;
}



