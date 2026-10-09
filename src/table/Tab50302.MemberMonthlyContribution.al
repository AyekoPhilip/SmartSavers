table 50302 "Member Monthly Contribution"
{
    Caption = 'Member Monthly Contribution';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Member Contribution";
    LookupPageId = "Member Contribution";
    fields
    {
        field(50009; "Account No."; Code[100])
        {
            Caption = 'Member No.';
            DataClassification = ToBeClassified;
            TableRelation = Member;
            Editable = false;
        
            trigger OnValidate()
            var
                Cust: Record Member;
            begin
                if Cust.Get("Account No.") then
                    "Employer Code" := Cust."Employer Code"
            end;
        }
        field(50010; "Type"; Enum "ProductAccountCategory")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50011; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                RSchedule: Record "Repayment Schedule";
                DefaultRepayment: Decimal;
                gensetup: Record "General Set-Up";
            begin
                gensetup.Get();
                DefaultRepayment := 0;
                if Type = Type::Loan then begin

                    if Amount <> 0 then begin

                        if Loan.Get("Application No.") then begin

                            RSchedule.Reset();
                            RSchedule.SetRange("No.", "Application No.");
                            if RSchedule.Find('-') then begin
                                DefaultRepayment := RSchedule."Monthly Repayment";
                                if not gensetup."Override Setup Control" then
                                    if Amount < DefaultRepayment then Error(ErrorLessMinRepayment, DefaultRepayment);
                            end;

                            Loan.CalcFields("Outstanding Balance");
                            Loan.Repayment := Amount;
                            if Loan.Repayment >= Loan."Outstanding Balance" then
                                Loan.Repayment := Loan."Outstanding Balance";
                            Loan.Modify(true)
                        end;
                    end;
                end;
                "Amount Off" := xRec.Amount;
            end;
        }
        field(50012; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50013; "Application No."; Code[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = if (Type = filter("Shares Capital" | "Shares Deposit" | "Registration Fee" | "Benevolent Fund" | Insurance | Other)) "Account Credit"."No." where("Member No." = field("Account No."), "Account Category" = field(Type)) else
            if
           (Type = filter("Specialty Savings" | "Women Savings" | Junior | "Certificates of Deposit" | "Money Market" | "Islamic Banking")) "Account Banking"."No." where("Member No." = field("Account No."), "Account Category" = field(Type)) else
            if
           (Type = const(Loan)) Loans."No." where("Outstanding Balance" = filter(> 0), "Account No." = field("Account No.")) else
            if (Type = const(KinAccount)) "Account Credit";
        
            trigger OnValidate()
            var
                Loan: Record Loans;
                CredAcc: Record "Account Credit";
                AccBanking: Record "Account Banking";
                PFact: Record "Product Factory";
            begin
                case Type of
                    Type::Loan:
                        begin
                            if Loan.Get("Application No.") then
                                "Product Type" := Loan."Product Type";
                            Amount := Loan.Repayment;
                            Remarks := Loan."Product Description";
                        end;
                    Type::"Registration Fee",
                    Type::"Shares Capital",
                    Type::"Benevolent Fund",
                    Type::Insurance,
                    Type::Other,
                    Type::"Shares Deposit":
                        begin
                            if CredAcc.Get("Application No.") then begin
                                "Product Type" := CredAcc."Product Type";
                                Remarks := CredAcc."Product Name";
                                PFact.Get(CredAcc."Product Type");
                                Amount := PFact."Minimum Contribution";
                            end
                        end;
                    Type::Savings,
                    Type::"Money Market",
                    Type::"Islamic Banking",
                    Type::"Specialty Savings":
                        begin
                            if AccBanking.Get("Application No.") then begin
                                "Product Type" := AccBanking."Product Type";
                                Remarks := AccBanking."Product Name";
                                PFact.Get(CredAcc."Product Type");
                                Amount := PFact."Minimum Contribution";
                            end
                        end;
                end;
            end;
        }
        field(50014; "Amount Off"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50015; "Advise Type"; Enum "AdviseType")
        {
            Caption = 'Advise Type';
        }
        field(50016; "Entry No."; Code[50])
        {

        }
        field(50017; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Editable = false;
        }
        field(50018; "Employer Code"; Code[20])
        {
            TableRelation = Customer where("Account Type" = filter(Employer));
        }
        field(50019; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(50020; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(50021; "Last Modified By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
    }
    keys
    {
        key("PK"; "Account No.", "Type", "Application No.", "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    begin
        "Last Modified Date" := Today;
        "Last Modified Time" := Time;
        "Last Modified By" := UserId;
    end;

    procedure CopyFromMembContributionApplicDetails(Application: Record "Monthly Contribution Applic.")
    begin
        Type := Application.Type;
        Amount := Application.Amount;
        Remarks := Application.Remarks;
        OnAfterCopyLinesFromApplicationContribution(Application, Rec);
    end;

    procedure CopyFromAccountApplicDetails(Application: Record "Account Application")
    begin
        Type := Application."Account Type";
        Amount := Application."Monthly Contribution";
        Remarks := Application."Product Name";
    end;

    local procedure OnAfterCopyLinesFromApplicationContribution(KinDetails: Record "Monthly Contribution Applic."; var VarVariant: Record "Member Monthly Contribution")
    begin

    end;

    var
        Loan: Record Loans;
        ErrorLessMinRepayment: Label 'Amount cannot be less than Default repayment of %1';



}



