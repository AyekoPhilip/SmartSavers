table 50597 "Cust. Bank Applic Change"
{
    Caption = 'Cust. Bank Applic Change';
    DataClassification = ToBeClassified;
    fields
    {
        field(50009; "Customer No."; Code[100])
        {
            Caption = 'Customer No.';
            NotBlank = true;
        }
        field(50010; "Code"; Code[20])
        {
            Caption = 'Bank Code';
            NotBlank = true;
            TableRelation = Banks;
        
            trigger OnValidate()
            var
                BankCode: Record Banks;
            begin
                BankCode.Reset();
                BankCode.SetRange(Code, Code);
                if BankCode.FindFirst() then
                    Name := BankCode.Name
            end;
        }
        field(50011; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(50012; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(50013; "Address"; Text[100])
        {
            Caption = 'Address';
        }
        field(50014; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(50015; "City"; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
        
            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;

                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50016; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
        
            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin

                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50017; "Contact"; Text[100])
        {
            Caption = 'Contact';
        }
        field(50018; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(50019; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(50020; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            TableRelation = "Bank Branches"."Branch Code" where("Bank Code" = field(Code));
        
            trigger OnValidate()
            var
                BnkBranch: Record "Bank Branches";
            begin
                BnkBranch.SetRange("Bank Code", Code);
                BnkBranch.SetRange("Branch Code", "Bank Branch No.");
                if BnkBranch.FindFirst() then
                    "Telex Answer Back" := BnkBranch."Branch Name";
            end;
        }
        field(50021; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            NotBlank = true;
        
            trigger OnValidate()
            begin
                "Bank Account No." := DelChr("Bank Account No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
            end;
        }
        field(50022; "Transit No."; Text[20])
        {
            Caption = 'Transit No.';
        }
        field(50023; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(50024; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        
            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(50025; "County"; Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }
        field(50026; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(50027; "Telex Answer Back"; Text[150])
        {
            Caption = 'Branch Name';
            Editable = false;
        }
        field(50028; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(50029; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(50030; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(50031; "IBAN"; Code[50])
        {
            Caption = 'IBAN';
        
            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
                IsHandled: Boolean;
            begin


                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(50032; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            TableRelation = "SWIFT Code";
            ValidateTableRelation = false;
        }
        field(50033; "Bank Clearing Code"; Text[50])
        {
            Caption = 'Bank Clearing Code';
        }
        field(50034; "Bank Clearing Standard"; Text[50])
        {
            Caption = 'Bank Clearing Standard';
            TableRelation = "Bank Clearing Standard";
        }
        field(50035; "Member No."; Code[100])
        {
            TableRelation = if ("Application Source" = filter(Member)) Member else
            if ("Application Source" = filter(Account)) "Account Banking" else
            if ("Application Source" = filter(Credit)) "Account Credit";
            DataClassification = CustomerContent;
        }
        field(50036; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50037; "Application No."; Code[50])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50038; "Application Source"; Option)
        {
            Editable = false;
            OptionMembers = "Member","Account","Credit";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key("Key1"; "Customer No.", "Code", "Bank Account No.", "Entry No.", "Application Source")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
        fieldgroup(Brick; "Code", Name, "Phone No.", Contact)
        {
        }
    }

    trigger OnDelete()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Customer No.", "Customer No.");
        CustLedgerEntry.SetRange("Recipient Bank Account", Code);
        CustLedgerEntry.SetRange(Open, true);
        if not CustLedgerEntry.IsEmpty() then
            Error(BankAccDeleteErr);
        UpdateCustPreferredBankAccountCode();
    end;

    trigger OnRename()
    begin
    end;

    var
        PostCode: Record "Post Code";
        BankAccIdentifierIsEmptyErr: Label 'You must specify either a Bank Account No. or an IBAN.';
        BankAccDeleteErr: Label 'You cannot delete this bank account because it is associated with one or more open ledger entries.';

    procedure GetBankAccountNoWithCheck() AccountNo: Text
    begin
        AccountNo := GetBankAccountNo();
        if AccountNo = '' then
            Error(BankAccIdentifierIsEmptyErr);
    end;

    procedure GetBankAccountNo(): Text
    var
        Handled: Boolean;
        ResultBankAccountNo: Text;
    begin

        if Handled then exit(ResultBankAccountNo);

        if IBAN <> '' then
            exit(DelChr(IBAN, '=<>'));

        if "Bank Account No." <> '' then
            exit("Bank Account No.");
    end;

    local procedure UpdateCustPreferredBankAccountCode()
    var
        CustomerLocal: Record Customer;
        IsHandled: Boolean;
    begin

        if CustomerLocal.Get("Customer No.") and (CustomerLocal."Preferred Bank Account Code" = Code) then begin
            CustomerLocal."Preferred Bank Account Code" := '';
            CustomerLocal.Modify();
        end;
    end;

}
