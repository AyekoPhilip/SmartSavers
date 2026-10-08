table 50013 "Cash Office User Template"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "UserID"; Code[50])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the user in the database';
            NotBlank = true;
            TableRelation = "User Setup"."User ID";
            Caption = 'UserID';
        }
        field(50010; "Receipt Journal Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const("Cash Receipts"));
            Caption = 'Receipt Journal Template';
        }
        field(50011; "Receipt Journal Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the receipt journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Receipt Journal Template"));
            Caption = 'Receipt Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/

                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Receipt Journal Template", "Receipt Journal Template");
                UserTemp.SetRange(UserTemp."Receipt Journal Batch", "Receipt Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50012; "Payment Journal Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the payment journal template in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            Caption = 'Payment Journal Template';
        }
        field(50013; "Payment Journal Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the payment journal batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
            Caption = 'Payment Journal Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Payment Journal Template", "Payment Journal Template");
                UserTemp.SetRange(UserTemp."Payment Journal Batch", "Payment Journal Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50014; "Petty Cash Template"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference to the petty cash payment voucher in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            Caption = 'Petty Cash Template';
        }
        field(50015; "Petty Cash Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Petty Cash Template"));
            Caption = 'Petty Cash Batch';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Petty Cash Template", "Petty Cash Template");
                UserTemp.SetRange(UserTemp."Petty Cash Batch", "Petty Cash Batch");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50016; "Inter Bank Template Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference of the petty cash payment batch in the database';
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            Caption = 'Inter Bank Template Name';
        }
        field(50017; "Inter Bank Batch Name"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference to the inter bank transfer batch in the database';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Inter Bank Template Name"));
            Caption = 'Inter Bank Batch Name';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/

                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Inter Bank Template Name", "Inter Bank Template Name");
                UserTemp.SetRange(UserTemp."Inter Bank Batch Name", "Inter Bank Batch Name");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same batch.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50018; "Default Receipts Bank"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference to the default receipts bank deposit account';
            TableRelation = "Bank Account"."No." where("Bank Type" = filter(Cash | "Chq Collection"));
            Caption = 'Default Receipts Bank';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Default Receipts Bank", "Default Receipts Bank");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50019; "Default Payment Bank"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference to the default payments bank deposit account';
            TableRelation = "Bank Account";
            Caption = 'Default Payment Bank';
        
            trigger OnValidate()
            begin
                /*Check if the batch has been allocated to another User*/
                UserTemp.Reset();
                UserTemp.SetRange(UserTemp."Default Payment Bank", "Default Payment Bank");
                if UserTemp.FindFirst() then begin
                    repeat
                        if UserTemp.UserId <> Rec.UserId then begin
                            Error('Please note that another user has been assigned the same bank.');
                        end;
                    until UserTemp.Next() = 0;
                end;

            end;
        }
        field(50020; "Default Petty Cash Bank"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference to the default petty cash account in the database';
            TableRelation = "Bank Account"."No." where("Bank Type" = const(Cash));
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
        field(50024; "Supervisor ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Stores the reference for the supervisor for the specific teller';
            Caption = 'Supervisor ID';
        
            trigger OnLookup()
            begin
                //LoginMgt.LookupUserID("Supervisor ID");
            end;

            trigger OnValidate()
            begin
                //LoginMgt.ValidateUserID("Supervisor ID");
            end;
        }
        field(50025; "Bank Pay In Journal Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name where(Type = const(General));
            Caption = 'Bank Pay In Journal Template';
        }
        field(50026; "Bank Pay In Journal Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Bank Pay In Journal Template"));
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
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Imprest Template';
        }
        field(50028; "Imprest  Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Imprest Template"));
            Caption = 'Imprest  Batch';
        }
        field(50029; "Claim Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
            Caption = 'Claim Template';
        }
        field(50030; "Claim  Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Claim Template"));
            Caption = 'Claim  Batch';
        }
        field(50031; "Advance Template"; Code[20])
        {
            Caption = 'Other Advance Template';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(50032; "Advance  Batch"; Code[20])
        {
            Caption = 'Other Advance  Batch';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Advance Template"));
        }
        field(50033; "Advance Surr Template"; Code[20])
        {
            Caption = 'Other Advance Surr Template';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(50034; "Advance Surr Batch"; Code[20])
        {
            Caption = 'Other Advance Surr Batch';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Advance Surr Template"));
        }
        field(50035; "Imprest Sur Template"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template".Name where(Type = const(Payments));
            Caption = 'Imprest Sur Template';
        }
        field(50036; "Imprest Sur Batch"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment Journal Template"));
            Caption = 'Imprest Sur Batch';
        }
         field(50037; "Responsibility Centre"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50038; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50039; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "UserID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserTemp: Record "Cash Office User Template";
}


