table 50374 "Dividend Progression"
{
    DataClassification = CustomerContent;


    fields
    {
        field(50009; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No"; Code[100])
        {
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }
        field(50011; "Processing Date"; Date)
        {
            Caption = 'Processing Date';
            DataClassification = CustomerContent;
        }
        field(50012; "Dividend Calc. Method"; Enum "DividendMethod")
        {
            Caption = 'Dividend Calc. Method';
            DataClassification = CustomerContent;
        }
        field(50013; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Pfact: Record "Product Factory";
            begin
                if Pfact.Get("Product Type") then begin
                    "Product Name" := Pfact.Description;
                    "Dividend Calc. Method" := Pfact."Dividend Calc. Method";
                    "Rcv Account Category" := Pfact."Account Category";
                    "Rcv Account Dimension" := Pfact."Account Dimension";
                end;
            end;
        }
        field(50014; "Product Name"; Text[150])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50015; "Member No"; Code[100])
        {
            Caption = 'Member No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                CustRecord.SetRange("No.", "Member No");
                if CustRecord.FindFirst() then begin
                    Name := CustRecord.Name;
                    "Employer Code" := CustRecord."Employer Code";
                    "Staff/Payroll No." := CustRecord."Payroll/Staff No.";
                end;
            end;
        }
        field(50016; "Qualifying Shares"; Decimal)
        {
            Caption = 'Qualifying Shares';
            DataClassification = CustomerContent;
        }
        field(50017; "Shares"; Decimal)
        {
            Caption = 'Shares';
            DataClassification = CustomerContent;
        }
        field(50018; "Gross Dividends"; Decimal)
        {
            Caption = 'Gross Dividends';
            DataClassification = CustomerContent;
        }
        field(50019; "Witholding Tax"; Decimal)
        {
            Caption = 'Witholding Tax';
            DataClassification = CustomerContent;
        }
        field(50020; "Net Dividends"; Decimal)
        {
            Caption = 'Net Dividends';
            DataClassification = CustomerContent;
        }
        field(50021; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(50022; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50023; "Payment Mode"; Code[20])
        {
            Caption = 'Payment Mode';
            DataClassification = CustomerContent;
        }
        field(50024; "Employer Code"; Code[10])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50025; "Header No."; Code[50])
        {
            Caption = 'Header No.';
            DataClassification = CustomerContent;
        }
        field(50026; "Posted"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(19; "Name"; Text[150])
        {
            Caption = 'Product Name';
            DataClassification = CustomerContent;
        }
        field(50028; "Staff/Payroll No."; Code[20])
        {
            Caption = 'Staff/Payroll No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Weighted Factor"; Decimal)
        {
            Caption = 'Weighted Factor';
            DataClassification = CustomerContent;
        }
         field(91000; "Rcv No. of Days"; Integer)
        {
            Caption = 'Day No.';
            DataClassification = CustomerContent;
        }
        field(91001; "Rcv Deposit Date"; Date)
        {
            Caption = 'Deposit Date';
            DataClassification = CustomerContent;
        }
        field(91002; "Rcv Interest Options"; Enum "Rcv12 Dividend Interest Option")
        {
            Caption = 'Interest Options';
        }
        field(91003; "Rcv RandomDigit"; Code[50])
        {
            Caption = 'Random Digit';
            DataClassification = CustomerContent;
        }
        field(91004; "Rcv Document Source"; Option)
        {
            OptionMembers = "Business Central","Online Slip";
            DataClassification = CustomerContent;
        }
          field(91005; "Rcv Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency."Code";
            DataClassification = CustomerContent;
        }
         field(91006; "Rcv Account Category"; Enum ProductAccountCategory)
        {
            Caption = 'Account Category';
            DataClassification = CustomerContent;
        }
         field(91007; "Rcv Account Dimension"; Enum AccountDimension)
        {
            DataClassification = CustomerContent;
            Caption = 'Account Dimension';
        }
    }

    keys
    {
        key("Key1"; "Account No", "Product Type", "Entry No.", "Header No.", "Start Date", "End Date")
        {
            Clustered = true;
        }
        key("Key2"; "Member No")
        {

        }
    }

    fieldgroups
    {
    }
     trigger OnInsert()
    begin
        "Rcv RandomDigit" := CreateGuid();
        "Rcv RandomDigit" := DelChr("Rcv RandomDigit", '=', '{}-01');
        "Rcv RandomDigit" := CopyStr("Rcv RandomDigit", 1, 8);
    end;

    procedure GetNextEntryNo() EntryNo: Integer
    var
        DividendProg: Record "Dividend Progression";
    begin
        DividendProg.Reset();
        DividendProg.SetRange("Header No.", "Header No.");
        if DividendProg.FindLast() then
            EntryNo := DividendProg."Entry No." + 1
        else
            EntryNo := 1;
    end;

    var
        CustRecord: Record Member;
}





