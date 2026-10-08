table 50075 "Treasury Office User Template"
{
    DataCaptionFields = UserID;
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "UserID"; Code[50])
        {
            Description = 'Stores the reference of the user in the database';
            NotBlank = true;
            DataClassification = CustomerContent;
            Caption = 'UserID';
        
            trigger OnLookup()
            begin
                // LoginMgt.LookupUserID(UserID);
            end;

            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID(UserID);
            end;
        }
        field(50010; "Receipt Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const("Cash Receipts"));
            DataClassification = CustomerContent;
            Caption = 'Receipt Journal Template';
        }
        field(50011; "Receipt Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Receipt Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Receipt Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/

                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if (UserTemp.UserId <> Rec.UserId) and ("Receipt Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50012; "Payment Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the payment journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            DataClassification = CustomerContent;
            Caption = 'Payment Journal Template';
        }
        field(50013; "Payment Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the payment journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Payment Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if (UserTemp.UserId <> Rec.UserId) and ("Payment Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50014; "Petty Cash Template"; Code[20])
        {
            Description = 'Stores the reference to the petty cash payment voucher in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Template';
        }
        field(50015; "Petty Cash Batch"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Petty Cash Template"));
            DataClassification = CustomerContent;
            Caption = 'Petty Cash Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Petty Cash Template", "Petty Cash Template");
                UserTemp.SetRange(UserTemp."Petty Cash Batch", "Petty Cash Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if (UserTemp.UserId <> Rec.UserId) and ("Petty Cash Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50016; "Inter Bank Template Name"; Code[20])
        {
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            DataClassification = CustomerContent;
            Caption = 'Inter Bank Template Name';
        }
        field(50017; "Inter Bank Batch Name"; Code[20])
        {
            Description = 'Stores the reference to the inter bank transfer batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Inter Bank Template Name"));
            DataClassification = CustomerContent;
            Caption = 'Inter Bank Batch Name';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/

                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Inter Bank Template Name", "Inter Bank Template Name");
                UserTemp.SetRange(UserTemp."Inter Bank Batch Name", "Inter Bank Batch Name");
                if UserTemp.FindFirst() then begin
                    repeat
                        if (UserTemp.UserId <> Rec.UserId) and ("Inter Bank Batch Name" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50018; "Default Receipts Bank"; Code[20])
        {
            Description = 'Stores the reference to the default receipts bank deposit account';
            TableRelation = "Bank Account"."No.";
            DataClassification = CustomerContent;
            Caption = 'Default Receipts Bank';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                /*UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Default Receipts Bank","Default Receipts Bank");
                if UserTemp.FindFirst() then
                  begin
                    repeat
                      if UserTemp.UserId<>Rec.UserId then
                        begin
                          Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next()=0;
                  end;
                  */

            end;
        }
        field(50019; "Default Payment Bank"; Code[20])
        {
            Description = 'Stores the reference to the default payments bank deposit account';
            TableRelation = "Bank Account";
            DataClassification = CustomerContent;
            Caption = 'Default Payment Bank';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                /*UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Default Payment Bank","Default Payment Bank");
                if UserTemp.FindFirst() then
                  begin
                    repeat
                      if UserTemp.UserId<>Rec.UserId then
                        begin
                          Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next()=0;
                  end;                */

            end;
        }
        field(50020; "Default Petty Cash Bank"; Code[20])
        {
            Description = 'Stores the reference to the default petty cash account in the database';
            TableRelation = "Bank Account"."No.";
            DataClassification = CustomerContent;
            Caption = 'Default Petty Cash Bank';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Default Petty Cash Bank", "Default Petty Cash Bank");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50021; "Max. Cash Collection"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Cash Collection';
        }
        field(50022; "Max. Cheque Collection"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Cheque Collection';
        }
        field(50023; "Max. Deposit Slip Collection"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Max. Deposit Slip Collection';
        }
        field(50024; "Supervisor ID"; Code[50])
        {
            Description = 'Stores the reference for the supervisor for the specific teller';
            DataClassification = CustomerContent;
            Caption = 'Supervisor ID';
        
            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID("Supervisor ID");
            end;

            trigger OnValidate()
            begin
                // LoginMgt.ValidateUserID("Supervisor ID");
            end;
        }
        field(50025; "Bank Pay In Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
            DataClassification = CustomerContent;
            Caption = 'Bank Pay In Journal Template';
        }
        field(50026; "Bank Pay In Journal Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Bank Pay In Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Bank Pay In Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Template", "Bank Pay In Journal Template");
                UserTemp.SetRange(UserTemp."Bank Pay In Journal Batch", "Bank Pay In Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50027; "Imprest Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Imprest Template';
        }
        field(50028; "Imprest  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Imprest Template"));
            DataClassification = CustomerContent;
            Caption = 'Imprest  Batch';
        }
        field(50029; "Claim Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Claim Template';
        }
        field(50030; "Claim  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Claim Template"));
            DataClassification = CustomerContent;
            Caption = 'Claim  Batch';
        }
        field(50031; "Advance Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Advance Template';
        }
        field(50032; "Advance  Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Advance Template"));
            DataClassification = CustomerContent;
            Caption = 'Advance  Batch';
        }
        field(50033; "Advance Surr Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Advance Surr Template';
        }
        field(50034; "Advance Surr Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Advance Surr Template"));
            DataClassification = CustomerContent;
            Caption = 'Advance Surr Batch';
        }
        field(50035; "Dim Change Journal Template"; Code[20])
        {
            Description = 'Stores the reference of the Dimensions/ GL journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
            DataClassification = CustomerContent;
            Caption = 'Dim Change Journal Template';
        }
        field(50036; "Dim Change Journal Batch"; Code[20])
        {
            Description = 'Stores the reference of the Dimensions/GL  journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Dim Change Journal Template"));
            DataClassification = CustomerContent;
            Caption = 'Dim Change Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if (UserTemp.UserId <> Rec.UserId) and ("Payment Journal Batch" <> '') then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50037; "Journal Voucher Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Journal Voucher Template';
        }
        field(50038; "Journal Voucher Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Voucher Template"));
            DataClassification = CustomerContent;
            Caption = 'Journal Voucher Batch';
        }
        field(50039; "Allow Posting of Receipts"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Posting of Receipts';
        }
        field(50040; "Allow Bank Selection"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Bank Selection';
        }
        field(50041; "Enter Backdated Receipts"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enter Backdated Receipts';
        }
    }

    keys
    {
        key("Key1"; "UserID")
        {

        }
    }

    fieldgroups
    {
    }

    var
        UserTemp: Record "Treasury Office User Template";
}


