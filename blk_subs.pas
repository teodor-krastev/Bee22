unit blk_subs;

interface
uses Classes, SysUtils, Math, pso_variable, System.Types, Generics.Collections,
  VCLTee.TeeInspector, UtilsU, MVC_U, TestFuncU;

type
  TClubsBlock = class(TblkModel)
  private
  public
    procedure Config(); override;
    procedure Init(); override;
    procedure DoChange(idx: integer); override;
  end;

  TSubSwBlock = class(TblkModel)
  public
    procedure Config(); override;
    procedure Init(); override;
    procedure DoChange(idx: integer); override;
  end;

implementation
uses pso_particle, pso_algo;
//£££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// Clubs Block

procedure TClubsBlock.Config();
begin

end;

procedure TClubsBlock.Init();
begin

end;

procedure TClubsBlock.DoChange(idx: integer);
begin

end;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
// Subs Block

procedure TSubSwBlock.Config();
begin

end;

procedure TSubSwBlock.Init();
begin

end;

procedure TSubSwBlock.DoChange(idx: integer);
begin

end;

end.
