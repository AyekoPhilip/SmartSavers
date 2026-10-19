namespace SaccoDB.SaccoDB;

enum 90004 "Protected Mob. Transaction"
{
    Extensible = true;
    
    value(0; "Restrict All")
    {
        Caption = 'Restrict All';
    }
    value(1; Loan)
  {
  Caption = 'Restrict Loan';
  }
  value(2; Withdrawal)
  {
  Caption = 'Restrict Withdrawal';
  }
  value(3; Balance)
  {
  Caption = 'Restrict  Enquiry';
  }
  value(4; Deposit)
  {
  Caption = 'Restrict Deposit';
  }
  value(5; Transfer)
  {
  Caption = 'Restrict Transfers';
  }
  value(6; Statement)
  {
  Caption = 'Restrict Statement';
  }
}
