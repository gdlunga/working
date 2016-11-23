library(RGtk2)

createWindow <- function()
{
  window <- gtkWindow()
  
  label <- gtkLabel("Hello World")
  window$add(label)
}

createWindow()
gtk.main()

demo(appWindow)

demo(package = 'RGtk2')
demo(treeStore)
