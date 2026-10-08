table 50423 "Banking User Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Account ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            Caption = 'Account ID';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50010; "Cashier Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Cashier Journal Template';
            DataClassification = CustomerContent;
        }
        field(50011; "Cashier Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cashier Journal Template"));
            Caption = 'Cashier Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cashier Journal Template", "Cashier Journal Template");
                UserTemp.SetRange(UserTemp."Cashier Journal Batch", "Cashier Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Cashier Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50012; "Salary Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Salary Journal Template';
            DataClassification = CustomerContent;
        }
        field(50013; "Salary Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Salary Journal Template"));
            Caption = 'Salary Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50014; "Default  Bank"; Code[50])
        {
            TableRelation = "Bank Account" where(Blocked = const(false), "Bank Type" = filter(Cash | Treasury), CashierID = field("Account ID"));
            Caption = 'Default  Bank';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default  Bank", "Default  Bank");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp."Account ID" <> "Account ID" then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50015; "Loans Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
            Caption = 'Loans Template';
            DataClassification = CustomerContent;
        }
        field(50016; "Loans Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Loans Template"));
            Caption = 'Loans Batch';
            DataClassification = CustomerContent;
        }
        field(50017; "Check Off Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General), Recurring = const(false));
            Caption = 'Check Off Template';
            DataClassification = CustomerContent;
        }
        field(50018; "Check Off Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Check Off Template"));
            Caption = 'Check Off Batch';
            DataClassification = CustomerContent;
        }
        field(50019; "Max. Deposit Limit"; Decimal)
        {
            Caption = 'Max. Deposit Limit';
            DataClassification = CustomerContent;
        }
        field(50020; "Max. Withdrawal Limit"; Decimal)
        {
            Caption = 'Max. Withdrawal Limit';
            DataClassification = CustomerContent;
        }
        field(50021; "Max. Cashier Withholding"; Decimal)
        {
            Caption = 'Max. Cashier Withholding';
            DataClassification = CustomerContent;
        }
        field(50022; "Min. Balance"; Decimal)
        {
            Caption = 'Min. Balance';
            DataClassification = CustomerContent;
        }
        field(50023; "Account No."; Code[50])
        {
            TableRelation = Member;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Account No.", "Account No.");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Account No." <> '') then begin
                            Error('Please note that another user has been assigned the same member No.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50024; "Bankers Cheque Account"; Code[50])
        {
            TableRelation = "Bank Account";
            Caption = 'Bankers Cheque Account';
            DataClassification = CustomerContent;
        }
        field(50025; "Type"; Option)
        {
            OptionCaption = ' ,Cashier,Treasury,Receipts,Application Document,Loans';
            OptionMembers = " ","Cashier","Treasury","Receipts","Application Document","Loans";
            Caption = 'Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Default  Bank" := '';
            end;
        }
        field(50026; "MPESA Disbursement A/c"; Code[50])
        {
            TableRelation = "Bank Account";
            Caption = 'MPESA Disbursement A/c';
            DataClassification = CustomerContent;
        }
        field(50027; "Cheque Disbursement A/c"; Code[50])
        {
            TableRelation = "Bank Account";
            Caption = 'Cheque Disbursement A/c';
            DataClassification = CustomerContent;
        }
        field(50028; "Bills Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Bills Template';
            DataClassification = CustomerContent;
        }
        field(50029; "Bills Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bills Template"));
            Caption = 'Bills Batch';
            DataClassification = CustomerContent;
        }
        field(50030; "Over Draft Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Over Draft Template';
            DataClassification = CustomerContent;
        }
        field(50031; "Over Draft Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cashier Journal Template"));
            Caption = 'Over Draft Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Over Draft Template", "Over Draft Template");
                UserTemp.SetRange(UserTemp."Over Draft Batch", "Over Draft Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Over Draft Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50032; "No of Open Transactions"; Integer)
        {
            Caption = 'No of Open Transactions';
            DataClassification = CustomerContent;
        }
        field(50033; "Interest Account Template"; Code[50])
        {
            Caption = 'Interest Account Template';
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
            DataClassification = CustomerContent;
        }
        field(50034; "Interest Account Batch"; Code[50])
        {
            Caption = 'Interest Account Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Interest Account Template"));
            DataClassification = CustomerContent;
        }
        field(50035; "Transfer Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
            Caption = 'Transfer Journal Template';
            DataClassification = CustomerContent;
        }
        field(50036; "Transfer Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Transfer Journal Template"));
            Caption = 'Transfer Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Transfer Journal Template", "Transfer Journal Template");
                UserTemp.SetRange(UserTemp."Transfer Journal Batch", "Transfer Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Transfer Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50037; "Excess Account"; Code[50])
        {
            TableRelation = "G/L Account";
            Caption = 'Excess Account';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Excess Account", "Excess Account");
                if UserTemp.FindFirst then begin
                    repeat
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50038; "Shortage Account"; Code[50])
        {
            TableRelation = "G/L Account";
            Caption = 'Shortage Account';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Shortage Account", "Shortage Account");
                if UserTemp.FindFirst then begin
                    repeat
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50039; "Cheque Clearance Account"; Code[50])
        {
            TableRelation = "Bank Account";
            Caption = 'Cheque Clearance Account';
            DataClassification = CustomerContent;
        }
        field(50040; "ATM Charges Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Purchases));
            Caption = 'ATM Charges Journal Template';
            DataClassification = CustomerContent;
        }
        field(50041; "ATM Charges Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("ATM Charges Journal Template"));
            Caption = 'ATM Charges Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50042; "Cheque Discounting Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Cheque Discounting Template';
            DataClassification = CustomerContent;
        }
        field(50043; "Cheque Discounting Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cheque Discounting Template"));
            Caption = 'Cheque Discounting Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cheque Discounting Template", "Cheque Discounting Template");
                UserTemp.SetRange(UserTemp."Cheque Discounting Batch", "Cheque Discounting Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Cheque Discounting Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50044; "Supervisor Mobile No."; Code[13])
        {
            CharAllowed = '0123456789';
            Caption = 'Supervisor Mobile No.';
            DataClassification = CustomerContent;
        }
        field(50045; "Supervisor E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50046; "Delegates Pay.Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Purchases));
            Caption = 'Delegates Pay.Journal Template';
            DataClassification = CustomerContent;
        }
        field(50047; "Delegates Pay. Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Delegates Pay.Journal Template"));
            Caption = 'Delegates Pay. Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50048; "Accrual. Fee.Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Purchases));
            Caption = 'Accrual. Fee.Journal Template';
            DataClassification = CustomerContent;
        }
        field(50049; "Accrual. Fee. Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Accrual. Fee.Journal Template"));
            Caption = 'Accrual. Fee. Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50050; "Responsibility Centre"; Code[50])
        {
            TableRelation = "Responsibility Center".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50051; "Shortcut Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50052; "Shortcut Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50053; "STO Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'STO Journal Template';
            DataClassification = CustomerContent;
        }
        field(50054; "STO Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("STO Journal Template"));
            Caption = 'STO Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cashier Journal Template", "Cashier Journal Template");
                UserTemp.SetRange(UserTemp."Cashier Journal Batch", "Cashier Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Cashier Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50055; "Commission Account"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Commission Account';
        }
        field(50056; "Member Commission"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Member Commission';
        }
        field(50057; "Periodic Journal Template"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Periodic Journal Template';
        }
        field(50058; "Periodic Journal Batch"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Periodic Journal Template"));
            Caption = 'Periodic Journal Batch';
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50059; "Treasury Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST("Cash Receipts"));
            Caption = 'Treasury Journal Template';
            DataClassification = CustomerContent;
        }
        field(50060; "Treasury Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Treasury Journal Template"));
            Caption = 'Treasury Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange("Treasury Journal Template", Rec."Treasury Journal Template");
                UserTemp.SetRange("Treasury Journal Batch", Rec."Treasury Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Cashier Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50061; "Mobile B2C A/c"; Code[50])
        {
            Caption = 'Mobile B2C A/c';
            TableRelation = "Bank Account"."No.";
            DataClassification = CustomerContent;
        }
        field(50062; "Reorder Level"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50063; "Default Bank C2B"; Code[50])
        {
            TableRelation = "Bank Account" where(Blocked = const(false));
            Caption = 'Default Bank C2B';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default  Bank", "Default Bank C2B");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp."Account ID" <> "Account ID" then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50064; "Default Bank C2C"; Code[50])
        {
            TableRelation = "Bank Account" where(Blocked = const(false));
            Caption = 'Default Bank C2C';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default  Bank", "Default Bank C2C");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp."Account ID" <> "Account ID" then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50065; "Alt. Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
            Caption = 'Alt. Channel Journal Template';
            DataClassification = CustomerContent;
        }
        field(50066; "Alt. Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Alt. Journal Template"));
            Caption = 'Alt. Channel Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Cashier Journal Template", "Cashier Journal Template");
                UserTemp.SetRange(UserTemp."Cashier Journal Batch", "Cashier Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Cashier Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50067; "Post As"; Option)
        {
            OptionMembers = "Post Amount","Post Less Charges";
        }
        field(50068; "Account Type"; Option)
        {
            OptionMembers = "Manual Posting","Automated Posting";
        }
        field(50069; "Mobile Corporate A/c"; Code[50])
        {
            TableRelation = "Bank Account" where(Blocked = const(false));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50070; "Vendor Comms. A/c"; Code[50])
        {
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            Caption = 'Vendor Commission. A/c';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50071; "Mobile Transaction In. A/c"; Code[50])
        {
            TableRelation = "G/L Account" where("Income/Balance" = filter("Income Statement"), "Direct Posting" = const(true));
            DataClassification = CustomerContent;
            Caption = 'Mobile Transaction Income. A/c';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50072; "Vendor Comms. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Commission. %';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50073; "ATM Clearing Account Comms. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'ATM Clearing Comms. (Amount / %)';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50074; "ATM Fee. %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'ATM Fee. (Amount / %)';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50075; "Coop Clearing Bank"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account" where("Bank Type" = const(Bank));
            Caption = 'ATM Clearing Bank';
        
            trigger OnValidate()
            begin
            end;
        }
        field(50076; "Bank C2B"; Code[50])
        {
            TableRelation = "Bank Account" where(Blocked = const(false));
            Caption = 'KCB Bank C2B';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Default  Bank", "Bank C2B");
                if UserTemp.FindFirst then begin
                    repeat
                        if UserTemp."Account ID" <> "Account ID" then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
        field(50077; "Utilities Account"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(50078; "Pr Salary Journal Template"; Code[50])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = Const(General));
            Caption = 'Payroll Salary Journal Template';
            DataClassification = CustomerContent;
        }
        field(50079; "Pr Salary Journal Batch"; Code[50])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Pr Salary Journal Template"));
            Caption = 'Payroll Salary Journal Batch';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                UserTemp.Reset;
                UserTemp.SetRange(UserTemp."Salary Journal Template", "Pr Salary Journal Template");
                UserTemp.SetRange(UserTemp."Salary Journal Batch", "Pr Salary Journal Batch");
                if UserTemp.FindFirst then begin
                    repeat
                        if (UserTemp."Account ID" <> "Account ID") and ("Pr Salary Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next = 0;
                end;
            end;
        }
          field(50080;"Default Bank Account (EFT)"; Code[10])

        {
            DataClassification = CustomerContent;
            TableRelation= "Bank Account" where("Bank Type"=filter(Bank),Blocked=filter(false));
        }

    }

    keys
    {
        key("Key1"; "Account ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Account ID", "Default  Bank", Type)
        {
        }
    }

    var
        UserTemp: Record "Banking User Template";


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for assistance';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




