namespace SaccoDatabase.SaccoDatabase;
using System.Security.AccessControl;

page 90011 "Board Allowances"
{
    ApplicationArea = All;
    Caption = 'Board Allowances';
    
    PageType = List;
    SourceTable = "Board allowance table";
    
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
        
            {
                field("Member Number"; Rec."Member Number")
                {
                    ToolTip = 'Specifies the value of the Member Number field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ToolTip = 'Specifies the value of the Member Name field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field("Payment type"; Rec."Payment type")
                {
                    ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ToolTip = 'Specifies the value of the Payment Date field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ToolTip = 'Specifies the value of the Amount Paid field.', Comment = '%';
                }
                field("Tax Paid"; Rec."Tax Paid")
                {
                    ToolTip = 'Specifies the value of the Tax Paid field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field("Tax amount"; Rec."Tax amount")
                {
                    ToolTip = 'Specifies the value of the Tax amount field.', Comment = '%';
                    Editable = Rec.Paid = false;
                }
                field(Paid; Rec.Paid)
                {
                    ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                   // Editable = Rec.Paid = false;
                }
                
            }
           
        }
         

    }
    actions
    {
        area(Processing)
        {
            action(Reject)
            {
                Image = Reject;
                ApplicationArea = All;
                ToolTip = 'Executes the Reject action';
                Caption = 'Reject Request';
                Enabled = PayrollUser;
                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to reject this request?', false) then begin
                        Rec.Paid := true;
                        Rec.Modify();
                        Message('%1 rejected successfully', Rec."Entry Number");
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Reject_Promoted; Reject)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
       
    end;
     trigger OnOpenPage()
    begin
       IF REC.PAID=false then
       CurrPage.Editable;

    end;

    var
        UserSetup: Record User;
        PayrollUser: Boolean;
}
   

