pageextension 50035 "Fixed Asset Card Page Ext" extends "Fixed Asset Card"
{

    layout
    {
        modify("Budgeted Asset")
        {
            Caption = 'Budgeted Asset/for budget purposes';
        }
        modify(DepreciationStartingDate)
        {
            ShowMandatory = true;
        }
        modify(NumberOfDepreciationYears)
        {
            ShowMandatory = true;
        }
        modify(Blocked)
        {
            Caption = 'Blocked/Fully Retired';
        }

        modify(Inactive)
        {
            Caption = 'Inactive/Partially Retired';
        }
        addlast(General)
        {
            field("Asset Tagging"; Rec."Asset Tagging")

            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Tagging field';
            }
            field("G/L Budget Line";Rec."G/L Budget Line")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the G/L Budget Line field';
            }
        }
        addlast("Depreciation Book")
        {
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FA Posting Group field';
            }
        }

        addlast(factboxes)
        {
           
        }
    }
    actions
    {
        addafter(Analysis)
        {
            action(SendApprovalRequest)
            {
                Caption = 'Send A&pproval Request';
                //Enabled = not OpenApprovalEntriesExist;
                Image = SendApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Executes the Send A&pproval Request action';
            }
        }

        addlast(processing)
        {
            action(GenerateBarcode)
            {
                Caption = 'Generate Barcode';
                Image = BarCode;
                ApplicationArea = All;
                ToolTip = 'Generates a Fixed Asset Barcode';

                trigger OnAction()
                begin
                    
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
            {
            }
            actionref(GenerateBarcode_Promoted; GenerateBarcode)
            {
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Deleting of fixed assets not permitted.Contact System administrator');
    end;

    var
      
}






