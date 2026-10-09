table 50350 "General Set-Up"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Max. Member Age"; DateFormula)
        {
            Caption = 'Max. Member Age';
            DataClassification = CustomerContent;
        }
        field(50011; "Registration Fee"; Decimal)
        {
            Caption = 'Registration Fee';
            DataClassification = CustomerContent;
        }
        field(50012; "Min. Member Age"; DateFormula)
        {
            Caption = 'Min. Member Age';
            DataClassification = CustomerContent;
        }
        field(50013; "Rejoining Fees Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Rejoining Fees Account';
            DataClassification = CustomerContent;
        }
        field(50014; "Days for Checkoff"; DateFormula)
        {
            Caption = 'Days for Checkoff';
            DataClassification = CustomerContent;
        }
        field(50015; "Guarantors Multiplier"; Decimal)
        {
            Caption = 'Guarantors Multiplier';
            DataClassification = CustomerContent;
        }
        field(50016; "Excise Duty G/L"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Excise Duty G/L';
            DataClassification = CustomerContent;
        }
        field(50017; "Rejoining Fee"; Decimal)
        {
            Caption = 'Rejoining Fee';
            DataClassification = CustomerContent;
        }
        field(50018; "Excise Duty (%)"; Decimal)
        {
            Caption = 'Excise Duty (%)';
            DataClassification = CustomerContent;
        }
        field(50019; "Max Loans To Guarantee"; Integer)
        {
            Caption = 'Max Loans To Guarantee';
            DataClassification = CustomerContent;
        }
        field(50020; "Bill Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = CONST(true));
            Caption = 'Bill Account';
            DataClassification = CustomerContent;
        }
        field(50021; "Funeral Expense Account"; Code[50])
        {
            TableRelation = "G/L Account";
            Caption = 'Funeral Expense Account';
            DataClassification = CustomerContent;
        }
        field(50022; "Funeral Amount"; Decimal)
        {
            Caption = 'Funeral Amount';
            DataClassification = CustomerContent;
        }
        field(50023; "Unloged Claims Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Unloged Claims Account';
            DataClassification = CustomerContent;
        }
        field(50024; "Insurance Name"; Text[30])
        {
            Caption = 'Insurance Name';
            DataClassification = CustomerContent;
        }
        field(50025; "Withdrawal Notice period"; DateFormula)
        {
            Caption = 'Withdrawal Notice period';
            DataClassification = CustomerContent;
        }
        field(50026; "Reference"; Text[30])
        {
            Description = 'Use to define Client Code for Electronic Find transfer';
            Caption = 'Reference';
            DataClassification = CustomerContent;
        }
        field(50027; "Withdrawal Fee"; Decimal)
        {
            Caption = 'Withdrawal Fee';
            DataClassification = CustomerContent;
        }
        field(50028; "Boosting Maturity"; DateFormula)
        {
            Caption = 'Boosting Maturity';
            DataClassification = CustomerContent;
        }
        field(50029; "Boosting Shares %"; Decimal)
        {
            Caption = 'Boosting Shares %';
            DataClassification = CustomerContent;
        }
        field(50030; "Share Boost GL"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Share Boost GL';
            DataClassification = CustomerContent;
        }
        field(50031; "Charge Type"; Code[50])
        {
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
        }
        field(50032; "Transaction Type [Statement]"; Code[20])
        {
            TableRelation = "Transaction Types" WHERE(Type = FILTER(Statement));
            Caption = 'Transaction Type [Statement]';
            DataClassification = CustomerContent;
        }
        field(50033; "External STO Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'External STO Account No.';
            DataClassification = CustomerContent;
        }
        field(50034; "Withdrawal Fee Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Withdrawal Fee Account';
            DataClassification = CustomerContent;
        }
        field(50035; "Self Guarantee %"; Decimal)
        {
            Caption = 'Self Guarantee %';
            DataClassification = CustomerContent;
        }
        field(50036; "Maximum Discounting %"; Decimal)
        {
            Caption = 'Maximum Discounting %';
            DataClassification = CustomerContent;
        }
        field(50037; "Special Charge on Loans GL"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Special Charge on Loans GL';
            DataClassification = CustomerContent;
        }
        field(50038; "BBF Claim %"; Decimal)
        {
            Caption = 'BBF Claim %';
            DataClassification = CustomerContent;
        }
        field(50039; "Enforce Picture & Signature"; Option)
        {
            Description = 'Enforce Picture & Signature';
            OptionCaption = ' ,Picture,Signature,Both';
            OptionMembers = " ","Picture","Signature","Both";
            Caption = 'Enforce Picture & Signature';
            DataClassification = CustomerContent;
        }
        field(50040; "Allowed Loan Categories"; Enum "LoanPerformanceIndicator")
        {
            Caption = 'Allowed Loan Categories';
            DataClassification = CustomerContent;
        }
        field(50041; "Benevolent Claim Account"; Code[50])
        {
            TableRelation = "G/L Account"."No.";
            Caption = 'Benevolent Claim Account';
            DataClassification = CustomerContent;
        }
        field(50042; "Maximum Valuation Period"; DateFormula)
        {
            Caption = 'Maximum Valuation Period';
            DataClassification = CustomerContent;
        }
        field(50043; "Maximum ATM Limit"; Decimal)
        {
            Caption = 'Maximum ATM Limit';
            DataClassification = CustomerContent;
        }
        field(50044; "Dividend Payable Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Dividend Payable Account';
            DataClassification = CustomerContent;
        }
        field(50045; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Withholding Tax Account';
            DataClassification = CustomerContent;
        }
        field(50046; "Min. Delegates deposit"; Decimal)
        {
            Caption = 'Min. Delegates deposit';
            DataClassification = CustomerContent;
        }
        field(50047; "Min.Delegate Membership Period"; DateFormula)
        {
            Caption = 'Min.Delegate Membership Period';
            DataClassification = CustomerContent;
        }
        field(50048; "Min. Delegates Share Capital"; Decimal)
        {
            Caption = 'Min. Delegates Share Capital';
            DataClassification = CustomerContent;
        }
        field(50049; "ATM Card No Characters"; Integer)
        {
            Caption = 'ATM Card No Characters';
            DataClassification = CustomerContent;
        }
        field(50050; "Self Deposits(As Guarantor)"; Boolean)
        {
            Caption = 'Self Deposits(As Guarantor)';
            DataClassification = CustomerContent;
        }
        field(50051; "Max. Member Age - Disabled"; DateFormula)
        {
            Caption = 'Max. Member Age - Disabled';
            DataClassification = CustomerContent;
        }
        field(50052; "BDE Loan Comission"; Decimal)
        {
            Caption = 'BDE Loan Comission';
            DataClassification = CustomerContent;
        }
        field(50053; "BDE Loan Above Target"; Decimal)
        {
            Caption = 'BDE Loan Above Target';
            DataClassification = CustomerContent;
        }
        field(50054; "BDE ATM Comission"; Decimal)
        {
            Caption = 'BDE ATM Comission';
            DataClassification = CustomerContent;
        }
        field(50055; "BDE New Member Comission"; Decimal)
        {
            Caption = 'BDE New Member Comission';
            DataClassification = CustomerContent;
        }
        field(50056; "BDE Salary Account Commision"; Decimal)
        {
            Caption = 'BDE Salary Account Commision';
            DataClassification = CustomerContent;
        }
        field(50057; "Block Account for Ext.  Loan"; Boolean)
        {
            Caption = 'Block Account for Ext.  Loan';
            DataClassification = CustomerContent;
        }
        field(50058; "Min.Retained Basic-Members"; Decimal)
        {
            Caption = 'Min.Retained Basic-Members';
            DataClassification = CustomerContent;
        }
        field(50059; "Min.Retained Basic-Staff"; Decimal)
        {
            Caption = 'Min.Retained Basic-Staff';
            DataClassification = CustomerContent;
        }
        field(50060; "Max. Allocation-Salary"; Decimal)
        {
            Caption = 'Max. Allocation-Salary';
            DataClassification = CustomerContent;
        }
        field(50061; "Retained Salary Earning %"; Decimal)
        {
            Caption = 'Retained Salary Earning %';
            DataClassification = CustomerContent;
        }
        field(50062; "Max. Share Boosting Amount"; Decimal)
        {
            Editable = true;
            Caption = 'Max. Share Boosting Amount';
            DataClassification = CustomerContent;
        }
        field(50063; "Max.Out. Loans-Fosa"; Decimal)
        {
            Caption = 'Max.Out. Loans-Fosa';
            DataClassification = CustomerContent;
        }
        field(50064; "BBF Prepayment %"; Decimal)
        {
            Caption = 'BBF Prepayment %';
            DataClassification = CustomerContent;
        }
        field(50065; "Max.Age Limit-Application"; DateFormula)
        {
            Caption = 'Max.Age Limit-Application';
            DataClassification = CustomerContent;
        }
        field(50066; "Max. Cash Boosted Amnt"; Decimal)
        {
            Caption = 'Max. Cash Boosted Amnt';
            DataClassification = CustomerContent;
        }
        field(50067; "Override Setup Control"; Boolean)
        {
            Caption = 'Override Setup Control';
            DataClassification = CustomerContent;
        }
        field(50068; "Membership Closure Control A/c"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No.";
            Caption = 'Membership Closure Control A/c';
        }
        field(50069; "Loans Closure Control A/c"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No.";
            Caption = 'Loans Closure Control A/c';
        }
        field(50070; "Min threshhold for Loan Applic"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Min threshhold for Loan Applic';
        }
        field(50071; "Dividend Expense Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Dividend Expense Account';
        }
        field(50072; "Nofity Guarantors"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Nofity Guarantors';
        }
        field(50073; "Interest Posting Method"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Accrual Basis,Cash Basis,Charge Daily';
            OptionMembers = " ","Accrual Basis","Cash Basis","Charge Daily";
            Caption = 'Interest Posting Method';
        }
        field(50074; "Max. Interest Chargeable"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Interest Chargeable';
        }
        field(50075; "Interest Rate Method"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Flat Amount,Tiered Amount';
            OptionMembers = "Flat Amount","Tiered Amount";
            Caption = 'Interest Rate Method';
        }
        field(50076; "Checkoff Control A/c"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Checkoff Control A/c';
        }
        field(50077; "Guarantorship Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Deposits,Available Shares,Shares Multiplier,Amount Guaranteed,Divide Equally';
            OptionMembers = " ","Deposits","Available Shares","Shares Multiplier","Amount Guaranteed","Divide Equally";
            Caption = 'Guarantorship Option';
        }
        field(50078; "Post Loan As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Create as User,Create Automatically';
            OptionMembers = " ","Create as User","Create Automatically";
            Caption = 'Post Loan As';
        }
        field(50079; "Post Membership As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Create as User,Create Automatically';
            OptionMembers = " ","Create as User","Create Automatically";
            Caption = 'Post Membership As';
        }
        field(50080; "Application Source (Member)"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Online,Mobile,CRM,CBS';
            OptionMembers = " ","Online","Mobile","CRM","CBS";
            Caption = 'Application Source (Member)';
        }
        field(50081; "Application Source (Loan)"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Online,Mobile,CRM,CBS';
            OptionMembers = " ","Online","Mobile","CRM","CBS";
            Caption = 'Application Source (Loan)';
        }
        field(50082; "Checkoff Cutoff Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Checkoff Cutoff Days';
        }
        field(50083; "Min No. of Guarantors"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Min No. of Guarantors';
        }
        field(50084; "Application Source (Account)"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Online,Mobile,CRM,CBS';
            OptionMembers = " ","Online","Mobile","CRM","CBS";
            Caption = 'Application Source (Account)';
        }
        field(50085; "Min No. of Kin-Signatory"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Min No. of Kin-Signatory';
        }
        field(50086; "Email Attachment Path"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50087; "Letter Header"; Blob)
        {
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
        field(50088; "Acivation Message"; Blob)
        {
            DataClassification = CustomerContent;
            Subtype = Memo;
        }
        field(50089; "Statement Frequency"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50090; "Safe Custody Frequency"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50091; "Dividend Qualify Formula"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Generate Automatically","Load Data";
        }
        field(50092; "Post As"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Job Queue","Web Service";
        }
        field(50093; "DMS Url"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50094; "Post Application As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Post as User,Post Automatically';
            OptionMembers = " ","Post as User","Post Automatically";
            Caption = 'Post Application As';
        }
        field(50095; "Area Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50096; "Max. Pensionable Age"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50097; "Appraise On Deposit Purchase"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50098; "Max. Retirement Age"; DateFormula)
        {
            DataClassification = CustomerContent;
        }
        field(50099; "Post Topup Charges"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Topup Loan Charges';
        }
        field(50100; "Max. Amount to Guarantee"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50101; "A/c Notice Charges Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Charge Early Exit Fee","Ignore Charges","Allow After Notice Expiry";
            OptionCaption = ' ,Charge Early Exit Fee,Ignore Charges,Allow Exit After Notice Expiry Date';
        }
        field(50102; "Refinance Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Full Refinance","Partial Refinance";
            OptionCaption = ' ,Full Refinance,Partial Refinance';
        }
        field(50103; "Loan Account Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Single","Multiple";
            OptionCaption = ' ,Single,Multiple';
        }
        field(99000; "Billing Type"; Enum "CreditBillingType")
        {
            Caption = 'Billing Type';
            DataClassification = CustomerContent;
        }
        field(99001; "Post As (EFT)"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"Job Queue","Web Service";

        }
        field(99002; "Journal Preview"; Enum "JournalPreview")
        {
            DataClassification = CustomerContent;
        }
        field(50107; "Interest Posting Based On"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "","Outstanding Principle","Outstanding Balance";
        }
    
        field(50104; "Interest Charged On"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Outstanding Balance","Outstanding Principal";
        }
        field(50105; "Refinancing Charged On"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Outstanding Balance","Outstanding Principal";
        }
        field(50106; "Interest Posting Options"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Post When Clearing Loan,Post Always';
            OptionMembers = "Post When Clearing Loan","Post Always";
            Caption = 'Cash Interest Posting Option';
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
        RestrictAccess(UserId)
    end;

    trigger OnInsert()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnModify()
    begin
        RestrictAccess(UserId)
    end;

    trigger OnRename()
    begin
        RestrictAccess(UserId)
    end;


    procedure RestrictAccess(UserNo: Code[100])
    var
        StatusPermission: Record "Status Change Permissions";
        ErrorOnRestrictViewTxt: Label 'You do not have permissions to MODIFY or DELETE on this Page. Contact your system administrator for further details';
    begin
        StatusPermission.Reset;
        StatusPermission.SetRange("User ID", UserNo);
        StatusPermission.SetRange("Edit Setup", true);
        if not StatusPermission.Find('-') then begin
            Error(ErrorOnRestrictViewTxt);
        end;
    end;
}




