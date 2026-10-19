reportextension 50000 "Change Password Ext" extends "Change Password"
{
    trigger OnPostReport()
    begin
        //insert to password log table
        Changepassword.Init();
        Changepassword.Validate("Last Password Change",Today);
        Changepassword."User Security ID":=UserSecurityId();
        Changepassword.UserName:=UserId;
       Changepassword.Insert();

        
    end;

    var
    Changepassword: Record "Password History";
}



