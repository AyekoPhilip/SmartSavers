table 50023 "Imprest Header"
{
    Caption = 'Imprest Header';
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'No.';
        
            trigger OnValidate()
            begin

              

            end;
        }
        field(50010; "Date"; Date)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Date';
        
            trigger OnValidate()
            begin


            end;
        }
        field(50011; "Pay Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Code';
        }
        field(50012; "Pay Mode"; Enum "PaymentMode")
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Mode';
        }
        field(50013; "Payee"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Payee';
            Editable = false;
        }
        field(50014; "On behalf of"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'On behalf of';
            Editable = false;
        }
        field(50015; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(50016; "Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted';
        }
        field(50017; "Posted By"; Code[50])
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Posted By';
        }
        field(50018; "Posted Date"; Date)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Posted Date';
        }
        field(50019; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(50020; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50021; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Posted';
        }
        field(50022; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines".Amount where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50023; "Paying Bank Account"; Code[20])
        {
            TableRelation = "Bank Account" where(Blocked = filter(false));
            DataClassification = CustomerContent;
            Caption = 'Paying Bank Account';
        
            trigger OnValidate()
            begin
                if Bank.Get("Paying Bank Account") then begin
                    "Bank Name" := Bank.Name;
                    Currency := Bank."Currency Code";
                end;
            end;
        }
        field(50024; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(50026; "Currency"; Code[20])
        {
            TableRelation = Currency;
            DataClassification = CustomerContent;
            Caption = 'Currency';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50027; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
        }
        field(50028; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Account Type';
        }
        field(50029; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const(Vendor)) Vendor;
            DataClassification = CustomerContent;
            Caption = 'Account No.';
        
            trigger OnValidate()
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            if GLAccount.Get("Account No.") then;
                            GLAccount.TestField("Direct Posting", true);
                            "Account Name" := GLAccount.Name;
                        end;
                    "Account Type"::Vendor:
                        begin
                            if Vendor.Get("Account No.") then;
                            Vendor.TestField(Blocked, Vendor.Blocked::" ");
                            "Account Name" := Vendor.Name;
                            Payee := Vendor.Name;
                        end;
                    "Account Type"::Customer:
                        begin
                            Customer.Get("Account No.");
                            Customer.TestField(Blocked, Customer.Blocked::" ");
                            "Account Name" := Customer.Name;
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            Bank.Get("Account No.");
                            "Account Name" := Bank.Name;
                            Currency := Bank."Currency Code";
                        end;
                    "Account Type"::"Fixed Asset":
                        begin
                            FixedAsset.Get("Account No.");
                            "Account Name" := FixedAsset.Description;
                        end;
                end;
            end;
        }
        field(50030; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Name';
        }
        field(50031; "Imprest Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines".Amount where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Imprest Amount';
        }
        field(50032; "Surrendered"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Surrendered';
        }
        field(50033; "Applies- To Doc No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Applies- To Doc No.';
        
            trigger OnLookup()
            begin

            end;
        }
        field(50034; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50025; "Payment Type"; Enum "PvPaymentType")
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Type';
        }
        field(50035; "Surrender Date"; Date)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Surrender Date';
        }
        field(50036; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }

        field(50037; "Travel Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Travel Date';
        }
        field(50038; "Cashier"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cashier';
        }
        field(50039; "Payment Release Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Release Date';
        }
        field(50040; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. Printed';
        }
        field(50041; "Surrender Status"; Option)
        {
            OptionCaption = ' ,Full,Partial';
            OptionMembers = " ","Full","Partial";
            DataClassification = CustomerContent;
            Caption = 'Surrender Status';
        }
        field(50042; "Departure Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Departure Date';
        }
        field(50043; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


            end;
        }

        field(50044; "Payment Narration"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Narration';
        }
        field(50045; "Total VAT Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."VAT Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total VAT Amount';
        }
        field(50046; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."W/Tax Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Witholding Tax Amount';
        }
        field(50047; "Total Net Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."Net Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Net Amount';
        }
        field(50048; "Total Payment Amount LCY"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."NetAmount LCY" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Payment Amount LCY';
        }
        field(50049; "Total Retention Amount"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."Retention Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Retention Amount';
        }
        field(50050; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50051; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }

        field(50052; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }

        field(50053; "Date Surrendered"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Surrendered';
        }
        field(50054; "Surrendered By"; Code[50])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'Surrendered By';
        }
        field(50055; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 5 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50056; "Imprest Issue Date"; Date)
        {
            Caption = 'Imprest Issue Date';
            DataClassification = CustomerContent;
        }
        field(50057; "Imprest Issue Doc. No"; Date)
        {
            DataClassification = CustomerContent;
            TableRelation = "Imprest Header" where("Account No." = field("Account No."), "Approval Status" = filter(Posted));
        }

        field(50058; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 6 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50059; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 7 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(50060; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 8 Code';
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(50061; "Issue Voucher Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        
            trigger OnValidate()
            begin

            end;
        }


        field(50062; "Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        
            trigger OnValidate()
            begin

            end;
        }
        field(50063; "Actual Spent"; Decimal)
        {
            Editable = false;
            CalcFormula = sum("Imprest Lines"."Actual Spent" where("Surrender Doc No." = field("No.")));
            FieldClass = FlowField;
            Caption = 'Actual Spent';
        }
        field(50064; "Amount Surrendered (LCY)"; Decimal)
        {
            Editable = false;
            CalcFormula = sum("Imprest Lines"."Actual Spent" where("Surrender Doc No." = field("No.")));
            FieldClass = FlowField;
            Caption = 'Amount Surrendered LCY';
        }

        field(50065; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        
            trigger OnLookup()
            begin

            end;
        }

        field(50066; "Bank Name"; Text[100])
        {
            CalcFormula = lookup("Bank Account".Name where("No." = field("Paying Bank Account")));
            Caption = 'Bank Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50067; "Notification Sent"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Notification Sent';
        }
        field(50068; "DateTime Sent"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'DateTime Sent';
        }
        field(50069; "Vendor Entry No"; Integer)
        {
            CalcFormula = lookup("Vendor Ledger Entry"."Entry No." where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Vendor Entry No';
        }
        field(50070; "User Id"; Code[30])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Caption = 'User Id';
        }
        field(50071; "User Department"; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
            Caption = 'User Department';
        }
        field(50072; "HOD Comments"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'HOD Comments';
        }
        field(50073; "Finance Comments"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Finance Comments';
        }
        field(50074; "HOD Approver"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HOD Approver';
        }
        field(50075; "Finance Approver"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Finance Approver';
        }
        field(50076; "ISD Department"; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ' ,ISD Support,ISD Programs';
            OptionMembers = " ","ISD Support","ISD Programs";
            DataClassification = CustomerContent;
            Caption = 'ISD Department';
        }
        field(50077; "Time Inserted"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Inserted';
        }
        field(50078; "Levied Invoice"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Levied Invoice';
        }

        field(50079; "Receiving Amount LCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Receiving Amount LCY';
        }
        field(50080; "Source Amount LCY"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Amount LCY';
        }
        field(50081; "Procurement Plan"; Code[15])
        {
            DataClassification = CustomerContent;
            Caption = 'Procurement Plan';
        }
        field(50082; "Check Printed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Check Printed';
        }
        field(50083; "EFT File Generated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'EFT File Generated';
        }
        field(50084; "EFT Reference"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'EFT Reference';
        }
        field(50085; "Imprest Receipt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Receipt';
        
            trigger OnValidate()
            begin
                if "Imprest Receipt" = true then
                    "Account Type" := "Account Type"::Customer;
            end;
        }
        field(50086; "Direct Expense"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Direct Expense';
        }
        field(50087; "Travel Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Local,Foreign';
            OptionMembers = "Local","Foreign";
            Caption = 'Travel Type';
        }
        field(50088; "Total Witholding VAT Tax"; Decimal)
        {
            CalcFormula = sum("Payment Lines"."W/T VAT Amount" where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Witholding VAT Tax';
        }
        field(50089; "Payee PIN"; Code[15])
        {
            DataClassification = CustomerContent;
            Caption = 'Payee PIN';
        }

        field(50090; "Imprest Surrender Receipt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Surrender Receipt';
        }
        field(50091; "Imprest Posted by PV"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Imprest Posted by PV';
        }
        field(50092; "EFT Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'EFT Date';
        }
        field(50093; "RTGS Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'RTGS Date';
        }

        field(50094; "Date Created"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Created';
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
        fieldgroup(DropDown; "No.", "Account Name")
        {
        }
    }

    trigger OnInsert()
    begin
        CashMgt.Get();
        CashMgt.TestField("Max Open Documents");
        GeneralLedgerSetup.Get();

        if "No." = '' then begin
            case "Payment Type" of
                "Payment Type"::Imprest:
                    begin
                        CashMgt.TestField("Max Open Documents");
                        CashMgt.TestField("Imprest Nos");
                        
                    end;
                "Payment Type"::"Imprest Surrender":
                    begin
                        CashMgt.TestField("Max Imprests Unsurrendered");
                        CashMgt.TestField("Imprest Surrender Nos");
                        
                    end;
            end;

        end;

        Date := Today;
        "Time Inserted" := Time;
        Cashier := UserId;
        "User Id" := UserId;
        "Created By" := UserId;

    end;

    var
        Bank: Record "Bank Account";
        CashMgt: Record "Cash Management Setups";
        ChequeRegister: Record "Cheque Register";
        CurrencyRec: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        Employee: Record Employee;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ImpSurrLines: Record "Payment Lines";
        PaymentLine: Record "Payment Lines";

        UserSetup: Record "User Setup";
        Vendor: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit "No. Series";
        ImpBalance: Decimal;
        Text003: Label 'By disabling Multi-Donor the dimensions on the lines shall be reset \ You wish to proceed?';
        SurrExistsError: Label 'Imprest issued document %1 has been used in another Imprest Surrender document %2';
        MultiDocError: Label 'Kindly utilize your open documents before creating a new one';
        AccountError: Label 'Please account for your previous %1 before applying for a new one';
        NoStaffNoError: Label 'Staff No. %1 can not be found in the Employees List. Kindly contact the system administrator.';
        Text001: Label 'The imprest %1 has been fully surrendered';
        Text002: Label 'The petty cash %1 has been fully surrendered';
        NoUserAcc: Label 'You do not have a user account. Please contact the system administrator.';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        CompletionDateFormula: Text;

    procedure GetPettyCashBank() PettyBank: Code[50]
    var
        Banks: Record "Bank Account";
    begin
        Banks.Reset();
        Banks.SetRange("Bank Type", Banks."Bank Type"::"Petty Cash");
        if Banks.FindFirst() then begin
            PettyBank := Banks."No.";
            exit(PettyBank);
        end;
    end;

    procedure MarkAsPosted()
    begin
        Posted := true;
        "Posted By" := UserId;
        "Posted Date" := Today;
        "Time Posted" := Time;
        Modify();
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posted Date", "No.");
        NavigateForm.Run();
    end;

    procedure PaymentLinesExist(): Boolean
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange(No, "No.");
        exit(PaymentLine.FindFirst());
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;
}
