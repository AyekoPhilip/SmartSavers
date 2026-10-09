page 50580 "Payroll Request Card"
{
    PageType = Card;
    SourceTable = "Payroll Requests";
    DeleteAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Rec.Status = Rec.Status::Open;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field(Applies; Rec.Applies)
                {
                    Caption = 'Applies To';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Applies To field';
                    Visible = false;

                    trigger OnValidate()
                    begin

                        case Rec.Applies of
                            Rec.Applies::All:
                                begin
                                    ShowAll := true;
                                    ShowGroup := false;
                                    ShowOne := false;
                                end;
                            Rec.Applies::Group:
                                begin
                                    ShowAll := false;
                                    ShowGroup := true;
                                    ShowOne := false;
                                end;
                            Rec.Applies::Specific:
                                begin
                                    ShowAll := false;
                                    ShowGroup := false;
                                    ShowOne := true;
                                end;
                        end;
                    end;
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Type field';
                }

                group(Control20)
                {
                    Visible = true;
                    Caption = 'Employee Information';

                    field("Employee No."; Rec."Employee No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Employee No. field';
                        Editable = false;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        Style = StandardAccent;
                        StyleExpr = true;
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Employee Name field';
                    }
                    field("Special Condition"; Rec."Special Condition")
                    {
                        Visible = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Special Condition field';

                        trigger OnValidate()
                        begin
                            if Rec."Special Condition" <> Rec."Special Condition"::" " then
                                NormalCondition := false
                            else
                                NormalCondition := true;
                        end;
                    }
                    field(Gratuity; Rec.Gratuity)
                    {
                        Visible = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Gratuity field';
                    }
                    field(Locum; Rec.Locum)
                    {
                        Visible = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Locum field';

                        trigger OnValidate()
                        begin
                            if Rec.Locum then
                                ShowLocum := true else
                                ShowLocum := false;
                        end;
                    }
                    group(Control25)
                    {
                        ShowCaption = false;
                        Visible = ShowLocum;

                        field("Principal Employee Code"; Rec."Principal Employee Code")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Principal Employee Code field';
                        }
                        field("Principal Employee Name"; Rec."Principal Employee Name")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Principal Employee Name field';
                        }
                        field("Principal Employee Basic"; Rec."Principal Employee Basic")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Principal Employee Basic field';
                        }
                        field(Hours; Rec.Hours)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Hours field';
                        }
                    }
                }
                group(Control28)
                {
                    ShowCaption = false;
                    Visible = NormalCondition;

                    field("Code"; Rec.Code)
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the value of the Code field';
                    }
                    field("Code Descripton"; Rec."Code Descripton")
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the value of the Code Descripton field';
                    }

                    field(Formula; Rec.Formula)
                    {
                        Editable = false;
                        Visible = Rec."Calculation Method" = Rec."Calculation Method"::Formula;
                        ApplicationArea = All;
                        Style = StandardAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the value of the Formula field';
                    }
                    field(Percentage; Rec.Percentage)
                    {
                        Editable = false;
                        Style = StandardAccent;
                        StyleExpr = true;
                        Visible = Rec."Calculation Method" = Rec."Calculation Method"::"% of Basic pay";
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Percentage field';
                    }
                    field(Units; Rec.Units)
                    {
                        Visible = false;
                        Style = StandardAccent;
                        StyleExpr = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Units field';
                    }
                }
                group("Overtime Calculation")
                {
                    field("Is Holiday"; Rec."Is Holiday")
                    {
                        ToolTip = 'Specifies the value of the  Working Days field.';
                        ApplicationArea = All;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field("Working Day Hours"; Rec."Working Day Hours")
                    {
                        ToolTip = 'Specifies the value of the  Working Days field.';
                        ApplicationArea = All;
                        Enabled = Rec."Is Holiday" = false;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field("Non-Working Day Hours"; Rec."Non-Working Day Hours")
                    {
                        ToolTip = 'Specifies the value of the Non-Working Days field.';
                        ApplicationArea = All;
                        Enabled = Rec."Is Holiday" = true;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }


                }
                group("Leave Allowance")
                {
                    Visible = Rec."Leave Allowance";
                    field("Leave Application Document"; Rec."Leave Application Document")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Leave Application Document field.';
                        Visible = false;
                    }
                    field("Total Leave Days Taken"; Rec."Total Leave Days Taken")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Total Leave Days Taken field.';
                        ShowMandatory = true;
                    }
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    Editable = Rec.Type = Rec.Type::Deduction;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Amount field';
                }
                group("Short Explanation")
                {
                    field(Remarks; Rec.Remarks)
                    {
                        ApplicationArea = All;
                        Style = StandardAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the value of the Remarks field';
                        ShowMandatory = true;
                        MultiLine = true;
                    }

                }
            }
            group("Trail Information")
            {
                Editable = false;
                field("Earliest Start Time"; Rec."Earliest Start Time")
                {
                    ToolTip = 'Specifies the value of the  Working Days field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Earliest End Time"; Rec."Earliest End Time")
                {
                    ToolTip = 'Specifies the value of the  Working Days field.';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Activity"; Rec."Date of Activity")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date of Activity field.';
                    ShowMandatory = true;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibility Center field';
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }

            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Open;
                ApplicationArea = All;
                ToolTip = 'Executes the Send Approval Request action';
                trigger OnAction()
                begin

                    Rec.TestField(Remarks);
                    Rec.TestField(Code);
                    Rec.TestField(Amount);
                    Rec.TestField("Employee No.");
                    ApprovalsMngt.OnSendPayrollRequest(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                ApplicationArea = All;
                ToolTip = 'Executes the Cancel Approval Request action';
                trigger OnAction()
                begin
                    ApprovalsMngt.OnCancelPayrollApprovalRequest(Rec, true, true);
                end;
            }
            action("Open Approval Request")
            {
                Image = Category;
                Enabled = Rec."Approval Status" = Rec."Approval Status"::Approved;
                ApplicationArea = All;
                ToolTip = 'Executes the Open Approval Request action';
                trigger OnAction()
                begin
                    //if Confirm('Are you sure?', false) then
                    // ApprovalsMngt.OnCancelPayrollRequestApprovalRequest(Rec);
                end;
            }
            action(Approval)
            {
                Caption = 'Approvals';
                Image = Approval;
                ApplicationArea = All;
                ToolTip = 'Executes the Approvals action';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetCurrentKey("Document No.");
                    ApprovalEntry.SetRange("Table ID", Database::"Payroll Requests");
                    ApprovalEntry.SetRange("Document No.", Rec."No.");
                    ApprovalEntries.SetTableView(ApprovalEntry);
                    ApprovalEntries.LookupMode(true);
                    ApprovalEntries.Run();
                end;
            }
            action(Calculate)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calculate action';
                Visible = false;

                trigger OnAction()
                begin
                    // PayrollMgt.GetPureFormula("Employee No.",PayrollMgt.GetCurrentPay(),Formula);
                    // Rec.UpdateChange();
                end;
            }
            action(Post)
            {
                Image = Post;
                Enabled = Rec.Status = Rec.Status::Approved;
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Executes the Post action';
                trigger OnAction()
                begin
                    //if Confirm('Are you sure you want to post?', false) then
                    //   PayrollMgt.PostPayrollRequest(Rec);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Approvals', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Send Approval Request_Promoted"; "Send Approval Request")
                {
                }
                actionref("Cancel Approval Request_Promoted"; "Cancel Approval Request")
                {
                }
                actionref("Open Approval Request_Promoted"; "Open Approval Request")
                {
                }
                actionref(Approval_Promoted; Approval)
                {
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.Applies := Rec.Applies::Specific;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        RecRef.SetRange("Created By", UserId);
        RecRef.SetRange("Approval Status", RecRef."Approval Status"::Open);
        if RecRef.Count > 1 then Error(ErrorOnMaxNoTransactions);
        Rec.Applies := Rec.Applies::Specific;
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance();

        NormalCondition := true;
        ShowAll := false;
        ShowGroup := false;
        ShowOne := false;
    end;

    var
        PayrollMgt: Codeunit "Payroll Post Mngt.";
        ApprovalsMngt: Codeunit "Approval Mgmt.";
        NormalCondition: Boolean;
        RecRef: Record "Payroll Requests";
        ShowAll: Boolean;
        ShowGroup: Boolean;
        ShowLocum: Boolean;
        ShowOne: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ErrorOnMaxNoTransactions: Label 'There are still pending applications. Please utilize them before you can continue.';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if (Rec.Status = Rec.Status::Approved) or (Rec.Status = Rec.Status::Rejected) then
            OpenApprovalEntriesExist := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId) //TRUE
        else
            OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId); //FALSE
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        case Rec.Applies of
            Rec.Applies::All:
                begin
                    ShowAll := true;
                    ShowGroup := false;
                    ShowOne := false;
                end;
            Rec.Applies::Group:
                begin
                    ShowAll := true;
                    ShowGroup := true;
                    ShowOne := false;
                end;
            Rec.Applies::Specific:
                begin
                    ShowAll := false;
                    ShowGroup := false;
                    ShowOne := true;
                end;
        end;
        if Rec.Locum then ShowLocum := true;
        if Rec."Special Condition" <> Rec."Special Condition"::" " then
            NormalCondition := false
        else
            NormalCondition := true;
    end;
}


