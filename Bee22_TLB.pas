unit Bee22_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 45604 $
// File generated on 01/03/2016 22:24:40 from Type Library described below.

// ************************************************************************  //
// Type Lib: G:\Bee22\Bee22 (1)
// LIBID: {F71CF999-EBBC-49E4-8EE8-C055B556E0B9}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  Bee22MajorVersion = 1;
  Bee22MinorVersion = 0;

  LIBID_Bee22: TGUID = '{F71CF999-EBBC-49E4-8EE8-C055B556E0B9}';

  IID_ICoBee22: TGUID = '{FA28279E-0D8E-4D2A-8A97-8EE5D1B7238A}';
  DIID_ICoBee22Events: TGUID = '{BD334F1C-4E82-49BC-B5B3-6695BE406451}';
  CLASS_CoBee22: TGUID = '{8F84B4D8-D2E6-46ED-85D9-41C96FE08E1F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  ICoBee22 = interface;
  ICoBee22Disp = dispinterface;
  ICoBee22Events = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  CoBee22 = ICoBee22;


// *********************************************************************//
// Interface: ICoBee22
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA28279E-0D8E-4D2A-8A97-8EE5D1B7238A}
// *********************************************************************//
  ICoBee22 = interface(IDispatch)
    ['{FA28279E-0D8E-4D2A-8A97-8EE5D1B7238A}']
    procedure Config; safecall;
    function Eval(const expr: WideString): OleVariant; safecall;
    function Exec(const code: WideString): WordBool; safecall;
    procedure Reset; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICoBee22Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA28279E-0D8E-4D2A-8A97-8EE5D1B7238A}
// *********************************************************************//
  ICoBee22Disp = dispinterface
    ['{FA28279E-0D8E-4D2A-8A97-8EE5D1B7238A}']
    procedure Config; dispid 201;
    function Eval(const expr: WideString): OleVariant; dispid 202;
    function Exec(const code: WideString): WordBool; dispid 203;
    procedure Reset; dispid 204;
  end;

// *********************************************************************//
// DispIntf:  ICoBee22Events
// Flags:     (0)
// GUID:      {BD334F1C-4E82-49BC-B5B3-6695BE406451}
// *********************************************************************//
  ICoBee22Events = dispinterface
    ['{BD334F1C-4E82-49BC-B5B3-6695BE406451}']
    function OnEpoch(const cmd: WideString; prm: OleVariant): OleVariant; dispid 201;
  end;

// *********************************************************************//
// The Class CoCoBee22 provides a Create and CreateRemote method to
// create instances of the default interface ICoBee22 exposed by
// the CoClass CoBee22. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoCoBee22 = class
    class function Create: ICoBee22;
    class function CreateRemote(const MachineName: string): ICoBee22;
  end;

implementation

uses System.Win.ComObj;

class function CoCoBee22.Create: ICoBee22;
begin
  Result := CreateComObject(CLASS_CoBee22) as ICoBee22;
end;

class function CoCoBee22.CreateRemote(const MachineName: string): ICoBee22;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CoBee22) as ICoBee22;
end;

end.

