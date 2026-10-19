table 50567 "Account (Procedure)"
{
    Caption = 'Account Banking-Temp';
    DataCaptionFields = "No.", Name;
    Permissions = TableData "Cust. Ledger Entry" = r;
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            SQLDataType = Varchar;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(50010; "Name"; Text[150])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := UpperCase(Name);
            end;
        }
        field(50011; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = CustomerContent;
        }
        field(50012; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            CharAllowed = '0123456789';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        }
        field(50013; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50014; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50015; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoEntriesExist(FieldCaption("No."), "No.");
            end;
        }
        field(50016; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(50017; "Comment"; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Customer),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Blocked"; Enum "Vendor Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(50019; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50020; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50021; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50022; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50023; "Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Banking A/c Ledger Entry".Amount WHERE("Customer No." = FIELD("No.")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Banking A/c Ledger Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                "Posting Date" = FIELD("Date Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "ATM Transactions"; Decimal)
        {
            CalcFormula = Sum("ATM Transaction".Amount WHERE("Account No" = FIELD("No."),
                                                              Posted = CONST(false)));
            FieldClass = FlowField;
            Caption = 'ATM Transactions';
        }
        field(50026; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50027; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(50028; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
            DataClassification = CustomerContent;
        }
        field(50029; "Status"; Enum "MemberStatus")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50030; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        }
        field(50031; "Group Account No"; Code[20])
        {
            Caption = 'Group Account No';
            DataClassification = CustomerContent;
        }
        field(50032; "Group Account"; Boolean)
        {
            Caption = 'Group Account';
            DataClassification = CustomerContent;
        }
        field(50033; "Product Type"; Code[20])
        {
            TableRelation = "Product Factory"."Product ID";
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if ProductFactory.Get("Product Type") then
                    "Product Name" := ProductFactory.Description;
            end;
        }
        field(50034; "Member No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50035; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50036; "Can Guarantee Loan"; Boolean)
        {
            Caption = 'Can Guarantee Loan';
            DataClassification = CustomerContent;
        }
        field(50037; "Loan Disbursement Account"; Boolean)
        {
            Caption = 'Loan Disbursement Account';
            DataClassification = CustomerContent;
        }
        field(50038; "Fixed Deposit Status"; Option)
        {
            OptionCaption = ' ,Active,Matured,Closed,Not Matured';
            OptionMembers = " ","Active","Matured","Closed","Not Matured";
            Caption = 'Fixed Deposit Status';
            DataClassification = CustomerContent;
        }
        field(50039; "ID/Passport No."; Code[20])
        {
            Caption = 'ID/Passport No.';
            DataClassification = CustomerContent;
        }
        field(50040; "Birth Certificate No."; Code[20])
        {
            Caption = 'Birth Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50041; "ATM No."; Code[20])
        {
            Editable = true;
            Caption = 'ATM No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateIdentityMask()
            end;
        }
        field(50042; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50043; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(50044; "Authorised Over Draft"; Decimal)
        {
            CalcFormula = Sum("Over Draft Authorisation"."Approved Amount" WHERE("Account No." = FIELD("No."),
                                                                                  Posted = CONST(true),
                                                                                  Expired = CONST(false)));
            FieldClass = FlowField;
            Caption = 'Authorised Over Draft';
        }
        field(50045; "Uncleared Cheques"; Decimal)
        {
            CalcFormula = Sum("Teller Transaction".Amount WHERE("Account No." = FIELD("No."),
                                                                 Posted = CONST(true),
                                                                 Type = FILTER("Cheque Deposit" | "Credit Cheque"),
                                                                 "Cheque Status" = CONST(Pending)));
            FieldClass = FlowField;
            Caption = 'Uncleared Cheques';
        }
        field(50046; "Fixed Deposit Type"; Code[20])
        {
            TableRelation = "Fixed Deposit Type";
            Caption = 'Fixed Deposit Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Registration Date");
                if FixedDepositType.Get("Fixed Deposit Type") then
                    "FD Maturity Date" := CalcDate(FixedDepositType.Duration, "Registration Date");
                "FD Duration" := FixedDepositType.Duration;
            end;
        }
        field(50047; "FD Maturity Date"; Date)
        {
            Caption = 'FD Maturity Date';
            DataClassification = CustomerContent;
        }
        field(50048; "Neg. Interest Rate"; Decimal)
        {
            Caption = 'Neg. Interest Rate';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CalcFields(Status, "Responsibility Center");
                FDCalcRules.Reset;
                FDCalcRules.SetRange(Code, "Fixed Deposit Type");
                if FDCalcRules.Find('-') then begin
                    repeat
                        if FDCalcRules."Allowed Margin" <> 0 then begin
                            if ("Fixed Deposit Amount" >= FDCalcRules."Minimum Amount") and
                              ("Fixed Deposit Amount" <= FDCalcRules."Maximum Amount") then
                                if ("Neg. Interest Rate" > (FDCalcRules."Interest Rate" + FDCalcRules."Allowed Margin")) or
                                   ("Neg. Interest Rate" < (FDCalcRules."Interest Rate" - FDCalcRules."Allowed Margin")) then
                                    Error(ErrorOnNonDisclosedNegRatetxt, FDCalcRules."Allowed Margin");
                        end;
                    until
                    FDCalcRules.Next = 0;
                end;
            end;
        }
        field(50049; "FD Duration"; DateFormula)
        {
            Caption = 'FD Duration';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Registration Date");
                "FD Maturity Date" := CalcDate("FD Duration", "Registration Date");
            end;
        }
        field(50050; "FD Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Transfer all to Savings,Renew Principal,Renew Principal & Interest';
            OptionMembers = " ","Transfer all to Savings","Renew Principal","Renew Principal & Interest";
            Caption = 'FD Maturity Instructions';
            DataClassification = CustomerContent;
        }
        field(50051; "Fixed Deposit Cert. No."; Code[30])
        {
            Caption = 'Fixed Deposit Cert. No.';
            DataClassification = CustomerContent;
        }
        field(50052; "Fixed Deposit Amount"; Decimal)
        {
            Caption = 'Fixed Deposit Amount';
            DataClassification = CustomerContent;
        }
        field(50053; "Savings Account No."; Code[20])
        {
            TableRelation = "Account Banking" WHERE("Member No." = FIELD("Member No."));
            Caption = 'Savings Account No.';
            DataClassification = CustomerContent;
        }
        field(50054; "Mobile No."; Text[30])
        {
            Caption = 'Mobile No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Cust: Record "Account Banking";
            begin
                CheckExistMobRegNo("Mobile No.");
            end;
        }
        field(50055; "Parent Account No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Parent Account No.';
            DataClassification = CustomerContent;
        }
        field(50056; "Last Withdrawal Date"; Date)
        {
            Caption = 'Last Withdrawal Date';
            DataClassification = CustomerContent;
        }
        field(50057; "Interest Transferred"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Interest Transferred';
        }
        field(50058; "Untranferred Interest"; Decimal)
        {
            CalcFormula = Sum("Interest Buffer"."Interest Amount" WHERE("Account No" = FIELD("No."),
                                                                         Transferred = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Untranferred Interest';
        }
        field(50059; "Lien Placed"; Decimal)
        {
            CalcFormula = Sum("Teller Transaction".Amount WHERE("Account No." = FIELD("No."),
                                                                 Posted = CONST(true),
                                                                 Type = FILTER(Lien),
                                                                 "Cheque Status" = CONST(Pending)));
            FieldClass = FlowField;
            Caption = 'Lien Placed';
        }
        field(50060; "Last Transaction Date"; Date)
        {
            CalcFormula = Max("Banking A/c Ledger Entry"."Posting Date" WHERE("Customer No." = FIELD("No.")));
            FieldClass = FlowField;
            Caption = 'Last Transaction Date';
        }
        field(50061; "Document No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Document No. Filter';
        }
        field(50062; "FD Date Renewed"; Date)
        {
            Caption = 'FD Date Renewed';
            DataClassification = CustomerContent;
        }
        field(50063; "Available Shares"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Available Shares';
        }
        field(50064; "Account Category"; Enum "ProductAccountCategory")
        {
            DataClassification = CustomerContent;
            Caption = 'Account Category';
        }
        field(50065; "Withdrawal Option"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Withdrawable,Non-withdrawable';
            OptionMembers = " ","Withdrawable","Non-withdrawable";
            Caption = 'Withdrawal Option';
        }
        field(50066; "Employer Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Employer Code';
        }
        field(50067; "Date of Birth"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Birth';
        }
        field(50068; "Account Dimension"; Enum "AccountDimension")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Account Dimension';
        }
        field(50069; "Staff/Payroll No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Staff/Payroll No.';
        }
        field(50070; "E-Mail"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail';
        }
        field(50071; "TestCode"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'TestCode';
        }
        field(50072; "Next Withdrawal Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Withdrawal Date';
            Editable = false;
        }
        field(50073; "Mobile Transaction Status"; Option)
        {
            OptionMembers = " ","Registered","Not Registered","Deactived";
            DataClassification = CustomerContent;
        }
        field(50074; "Signing Mandates"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50075; "Last Date Modified-Dormancy"; Date)
        {
            Caption = 'Last Date Modified-Dormancy';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50076; "Card Status"; Option)
        {
            Editable = false;
            OptionMembers = "Open","Pending Approval","Approved","Rejected","Posted";
            OptionCaption = 'Open,"Pending Approval",Active,Rejected,Blocked';
            DataClassification = CustomerContent;
        }
        field(50077; "Expiry Date (Card)"; Date)
        {
            Editable = false;
        }
        field(50078; "Old Account No."; Code[100])
        {
            Editable = false;
        }
        field(50079; "Internet Banking"; Option)
        {
            OptionMembers = " ","Registered","Not Registered","Deactived";
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
        fieldgroup(DropDown; "No.", Name, "Fixed Deposit Cert. No.", "Employer Code", "FD Maturity Instructions")
        {
        }
    }

    trigger OnDelete()
    begin
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text002: Label 'Do you wish to create a contact for %1 %2?';
        DimMgt: Codeunit DimensionManagement;
        Text004: Label 'post';
        Text005: Label 'create';
        MemberExistError: Label 'ATM Card No. Already exists with member %1 Name: %2';
        MemberExistErrorPhone: Label 'Phone No. Already exists with member %1 Name: %2';
        Text006: Label 'You cannot %1 this type of document when Customer %2 is blocked with type %3';
        ProductFactory: Record "Product Factory";
        Text016: Label 'You cannot Modify %1 %2 because there is at least one transaction %3 for this Member.';
        FixedDepositType: Record "Fixed Deposit Type";
        FDCalcRules: Record "FD Interest Calculation Rules";
        ErrorOnNonDisclosedNegRatetxt: Label 'The negotiated rate must be within the allowed margin of %1';


    procedure TestNoEntriesExist(CurrentFieldName: Text[100]; GLNO: Code[20])
    var
        MemberLedgEntry: Record "Banking A/c Ledger Entry";
    begin
        MemberLedgEntry.SetCurrentKey(MemberLedgEntry."Customer No.");
        MemberLedgEntry.SetRange(MemberLedgEntry."Customer No.", "No.");
        if MemberLedgEntry.Find('-') then
            Error(
            Text016,
             CurrentFieldName, "No.", Name);
    end;

    procedure CheckExistMobRegNo(MobileNo: Code[20])
    var
        Cust: Record "Account (Procedure)";
    begin
        if MobileNo <> '' then begin

            Cust.Reset;
            Cust.SetRange("Mobile No.", MobileNo);
            if Cust.Count > 1 then
                Error(MemberExistErrorPhone, Cust."Mobile No.", Cust."No.", Cust.Name);
        end
    end;

    procedure AssistEdit(OldCust: Record "Account Banking"): Boolean
    begin
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if "No." = '' then
            exit;

        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if not ContBusRel.FindFirst then begin
            if not Confirm(Text002, false, TableCaption, "No.") then
                exit;
            ContBusRel.FindFirst;
        end;
        Commit;

        Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
        Cont.SetRange("Company No.", ContBusRel."Contact No.");
        PAGE.Run(PAGE::"Contact List", Cont);
    end;


    procedure CheckBlockedCustOnJnls(Cust2: Record "Account (Procedure)"; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; Transaction: Boolean)
    begin
        if (Cust2.Blocked = Cust2.Blocked::All) or
   ((Cust2.Blocked = Cust2.Blocked::Payment) and (DocType in [DocType::Invoice, DocType::" "]))
then
            Cust2.CustBlockedErrorMessage(Cust2, Transaction)
    end;


    procedure CustBlockedErrorMessage(Cust2: Record "Account (Procedure)"; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
        if Transaction then
            Action := Text004
        else
            Action := Text005;
        Error(Text006, Action, Cust2."No.", Cust2."Balance (LCY)");
    end;

    procedure fnValidateIdentityMask()
    AccT: Record "Account Banking";
    begin

        "ATM No." := DelChr("ATM No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+');

        if "ATM No." <> '' then begin
            AccT.Reset;
            AccT.SetRange("ATM No.", "ATM No.");
            if AccT.FindFirst then begin
                if AccT."No." <> "No." then
                    Error(MemberExistError, AccT."ATM No.", AccT.Name);
            end;
        end;
    end;

    procedure GetSMSFieldName(SavingsAccounts: Record "Account (Procedure)") RetunField: Text[20]
    var
        SMSCodes: Record "SMS Codes";
        TableName: Text;
        i: Integer;
        FieldName: array[5] of Text;
    begin
        TableName := SavingsAccounts.TableName;

        i := 1;
        SMSCodes.Reset;
        SMSCodes.SetRange(SMSCodes."Table Name", TableName);
        if SMSCodes.Find('-') then begin
            repeat
                SMSCodes.CalcFields(SMSCodes."Field Name");
                FieldName[i] := SMSCodes."Field Name";
                i += i;
            until SMSCodes.Next = 0;
            RetunField := Format(FieldName[1]) + '[' + Format(FieldName[2]) +
            '[' + Format(FieldName[3]) + '[' + Format(FieldName[4]) + '[' + Format(FieldName[5]);
        end;
    end;


    procedure CopyFromMemberApplicationEntries(MemberApplication: Record "Member Application")
    begin

        Validate(Name, MemberApplication.Name);
        "ID/Passport No." := MemberApplication."ID No.";
        "Phone No." := MemberApplication."Phone No.";
        "Mobile No." := MemberApplication."Mobile Phone No";
        Status := Status::New;
        "Registration Date" := Today;
        "Date of Birth" := MemberApplication."Date of Birth";
        "Created By" := MemberApplication."Created By";
        "Birth Certificate No." := MemberApplication."Birth Certificate No.";
        "Employer Code" := MemberApplication."Employer Code";
        "Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
        "Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
        "Group Account No" := MemberApplication."Group Account No.";
        "Group Account" := MemberApplication."Group Account";
        "Staff/Payroll No." := MemberApplication."Payroll No.";
    end;


    procedure CopyFromCustomerMemberEntries(CustomerMember: Record Member)
    begin
        Validate(Name, CustomerMember.Name);
        "ID/Passport No." := CustomerMember."ID No.";
        "Phone No." := CustomerMember."Phone No.";
        "Mobile No." := CustomerMember."Mobile Phone No";
        Status := Status::New;
        "Registration Date" := Today;
        "Date of Birth" := CustomerMember."Date of Birth";
        "Created By" := CustomerMember."Created By";
        "Employer Code" := CustomerMember."Employer Code";
        "Global Dimension 1 Code" := CustomerMember."Global Dimension 1 Code";
        "Global Dimension 2 Code" := CustomerMember."Global Dimension 2 Code";
        "Group Account No" := CustomerMember."Group Account No.";
        "Group Account" := CustomerMember."Group Account";
        "Employer Code" := CustomerMember."Employer Code";
        "Date of Birth" := CustomerMember."Date of Birth";
    end;
}




