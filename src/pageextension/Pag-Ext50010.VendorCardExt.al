pageextension 50010 "VendorCardExt" extends "Vendor Card"
{
    layout
    {

        addlast(General)
        {
            field("Vendor Type"; Rec."Vendor Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Type field';
            }
            field("KRA PIN"; Rec."KRA PIN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the KRA PIN field.';
                Caption='TIN';
                ShowMandatory = true;
            }
            field("PIN Certificate Expiry"; Rec."PIN Certificate Expiry")
            {
                Caption = 'Tax compliance expiry date';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tax compliance expiry date field';
            }
        }
    }

    actions
    {

        modify(PayVendor)
        {
            Visible = false;
        }
        addlast(processing)
        {
            action(Evaluate)
            {
                Caption = 'Send for Evaluation';
                Image = SendConfirmation;
                ApplicationArea = All;
                ToolTip = 'Executes the Send for Evaluation action';

                trigger OnAction()
                begin
                    
                end;
            }



        }
        addfirst(Category_Process)
        {
            actionref(Evaluate_Promoted; Evaluate)
            {
            }
        }
    }

    var
        
}


