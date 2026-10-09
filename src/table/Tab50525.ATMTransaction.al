table 50525 "ATM Transaction"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "ATM Transactions";
    LookupPageId = "ATM Transactions";
    fields
    {
        field(50009; "Trace ID"; Code[100])
        {
            Caption = 'Trace ID';
            DataClassification = CustomerContent;
        }
        field(50010; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(50011; "Account No"; Code[100])
        {
            Editable = false;
            Caption = 'Account No';
            DataClassification = CustomerContent;
        }

        field(50012; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50013; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50014; "Postings"; Text[50])
        {
            Caption = 'Postings';
            DataClassification = CustomerContent;
        }
        field(50015; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50016; "Unit ID"; Code[10])
        {
            Caption = 'Unit ID';
            DataClassification = CustomerContent;
        }
        field(50017; "Transaction Type"; Enum "MobileTransactionTypes")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Trans Time"; Text[50])
        {
            Caption = 'Trans Time';
            DataClassification = CustomerContent;
        }
        field(50019; "Transaction Time"; Time)
        {
            Caption = 'Transaction Time';
            DataClassification = CustomerContent;
        }
        field(50020; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            DataClassification = CustomerContent;
        }
        field(50021; "Source"; Option)
        {
            OptionMembers = "ATM","Mobile","Bank Deposit";
            Caption = 'Source';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                TerminalSource: Code[100];
            begin
                TerminalSource := '';

                Case Source of
                    Source::ATM:
                        begin
                            TerminalSource := CopyStr(Description, 1, 3);
                            case
                                TerminalSource of
                                'POS':
                                    begin
                                        "Terminal Source Charge" := "Terminal Source Charge"::POS;
                                        "Transaction Type Charges" := "Transaction Type Charges"::POS;
                                        TransType.Reset();
                                        TransType.SetRange(Type, TransType.Type::POS);
                                        if TransType.FindFirst() then
                                            "Charge Code" := TransType.Code;
                                    end;
                                'ATM':
                                    begin
                                        "Terminal Source Charge" := "Terminal Source Charge"::ATM;
                                        "Transaction Type Charges" := "Transaction Type Charges"::ATM;
                                        TransType.Reset();
                                        TransType.SetRange(Type, TransType.Type::ATM);
                                        if TransType.FindFirst() then
                                            "Charge Code" := TransType.Code;
                                    end;
                                'VIS':
                                    begin
                                        "Terminal Source Charge" := "Terminal Source Charge"::VISA;
                                        "Transaction Type Charges" := "Transaction Type Charges"::VISA;
                                        TransType.Reset();
                                        TransType.SetRange(Type, TransType.Type::VISA);
                                        if TransType.FindFirst() then
                                            "Charge Code" := TransType.Code;
                                    end;
                                'BRA':
                                    begin
                                        "Terminal Source Charge" := "Terminal Source Charge"::BRANCH;
                                        "Transaction Type Charges" := "Transaction Type Charges"::BRANCH;
                                        TransType.Reset();
                                        TransType.SetRange(Type, TransType.Type::"Coop Branch");
                                        if TransType.FindFirst() then
                                            "Charge Code" := TransType.Code;
                                    end;
                            end;
                        end;
                end;

            end;
        }
        field(50022; "Reversed"; Boolean)
        {
            Caption = 'Reversed';
            DataClassification = CustomerContent;
        }
        field(50023; "Reversed Posted"; Boolean)
        {
            Editable = true;
            Caption = 'Reversed Posted';
            DataClassification = CustomerContent;
        }
        field(50024; "Reversal Trace ID"; Code[20])
        {
            Caption = 'Reversal Trace ID';
            DataClassification = CustomerContent;
        }
        field(50025; "Transaction Description"; Text[100])
        {
            Caption = 'Transaction Description';
            DataClassification = CustomerContent;
        }
        field(50026; "Withdrawal Location"; Text[150])
        {
            Caption = 'Withdrawal Location';
            DataClassification = CustomerContent;
        }
        field(50027; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50028; "Transaction Type Charges"; Enum "MobTransactionTypes")
        {
            Caption = 'Transaction Type Charges';
            DataClassification = CustomerContent;
        }
        field(50029; "Card Acceptor Terminal ID"; Code[20])
        {
            Caption = 'Card Acceptor Terminal ID';
            DataClassification = CustomerContent;
        }
        field(50030; "ATM Card No"; Code[20])
        {
            Caption = 'ATM Card No';
            DataClassification = CustomerContent;
        }
        field(50031; "Customer Names"; Text[100])
        {
            Caption = 'Customer Names';
            DataClassification = CustomerContent;
        }
        field(50032; "Process Code"; Code[20])
        {
            Caption = 'Process Code';
            DataClassification = CustomerContent;
        }
        field(50033; "Is Coop Bank"; Boolean)
        {
            Caption = 'Is Coop Bank';
            DataClassification = CustomerContent;
        }
        field(50034; "POS Vendor"; Option)
        {
            OptionCaption = 'ATM Lobby,Coop,Sacco';
            OptionMembers = "ATM Lobby","Coop","Sacco";
            Caption = 'POS Vendor';
            DataClassification = CustomerContent;
        }
        field(50035; "Reference No"; Text[100])
        {
            Caption = 'Reference No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Source = Source::ATM then begin
                    fnValidateID();

                end else begin
                    "Document No." := "Reference No";

                end;
            end;
        }
        field(50036; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Posted By';
        }
        field(50037; "Error Log"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Error Log';
        }
        field(50038; "Transaction Charge Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Charge Code';
            Editable = false;
        
            trigger OnValidate()
            var

            begin
                getTransactionCharge();
            end;
        }
        field(50039; "Phone No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50040; "Charge Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50041; "Charge Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Transaction Types";
            Editable = false;
        }
        field(50042; "Account No.(Credit)"; Code[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50043; "Search Code"; Code[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50044; "Terminal Source Charge"; Option)
        {
            Editable = false;
            OptionMembers = " ","ATM","POS","VISA","BRANCH";
            DataClassification = CustomerContent;
        }
        field(50045; "Document No."; Code[100])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    
        field(50046; "Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Trace ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    procedure getTransactionCharge()
    begin
        case "Transaction Charge Code" of
            '310000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Balance Enquiry";
                    "Transaction Type" := "Transaction Type"::"Balance Enquiry";

                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::"Balance Enquiry");
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;
            '350000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Full Statement";
                    "Transaction Type" := "Transaction Type"::Statement;

                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::Statement);
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;

                end;
            '380000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Mini Statement";
                    "Transaction Type" := "Transaction Type"::Statement;

                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::Ministatement);
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;
            '400000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Funds Transfer";
                    "Transaction Type" := "Transaction Type"::"Funds Transfer";
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::Transfers);
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;

            '500000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Utility Payment";
                    "Transaction Type" := "Transaction Type"::Bill;

                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::Utility);
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;

            '420000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Airtime Purchase";
                    "Transaction Type" := "Transaction Type"::Airtime;
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::Utility);
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;

            '220000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Cash Withdrawal - Coop ATM";
                    "Transaction Type" := "Transaction Type"::Withdrawal;
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::"Mobile Withdrawal");
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;
            '430000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Pos-cash Withdrawal";
                    "Transaction Type" := "Transaction Type"::Withdrawal;
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::"Mobile Withdrawal");
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;

            '210000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"POS - Cash Deposit";
                    "Transaction Type" := "Transaction Type"::Deposit;
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::"Cash Deposit");
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end;
            '450000':
                begin
                    "Transaction Type Charges" := "Transaction Type Charges"::"Cash Deposit";
                    "Transaction Type" := "Transaction Type"::Deposit;
                    TransType.Reset();
                    TransType.SetRange(Type, TransType.Type::"Ms Deposit");
                    if TransType.FindFirst() then
                        "Charge Code" := TransType.Code;
                end
        end

    end;

    procedure fnValidateID()
    begin
        "Document No." := DelChr("Reference No", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');

    end;

    var
        TransType: Record "Transaction Types";
        TransCharge: Record "Transaction Charge";
}




