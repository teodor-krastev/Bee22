import win32com.client
o = win32com.client.Dispatch("Bee22.coBee22")
print o.Eval("term.getP('max.iters')")
o.Exec("term.setP('max.iters',222)")
