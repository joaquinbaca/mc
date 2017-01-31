                 /*----- Sección de Declaraciones --------------*/  
%{ 
#include <stdio.h> 
int  numeroTotalUrl, numeroTotalTitulo, numeroTotalAutor;
char autor[1000];
char autorProcesado[100];
char fecha[1000];
char titulo[1000];
char tituloProcesado[1000];
char urlProcesado[1000];
char url[1000];
int contAutor=0;
int tamanoAutor; 
int primeraVez=1;
void escribir_datos (int dato1, int dato2, int dato3); 
void escribir_autor();
void escribir_titulo();
void escribir_url();
%} 
%% 
.|\n         {}        /*----- Sección de Reglas ----------------*/  

.*autor-texto.*\n.*autor-nombre.*\n<a.*>\n.*      { numeroTotalAutor=yyleng; strncpy(autor, yytext,yyleng);} /*De aqui sacamos todo el texto html referente al autor*/
 meta.property..og:title.*             { numeroTotalTitulo=yyleng; strncpy(titulo, yytext,yyleng);} /*De aqui sacamos todo el texto html referente al titulo*/
 meta.property..og:url.*.html               { numeroTotalUrl=yyleng; strncpy(url, yytext,yyleng);} /*De aqui sacamos todo el texto html referente a la url*/
%%    
                /*----- Sección de Procedimientos --------*/  
int main (int argc, char *argv[]) {    
  if (argc == 2)   {     
    yyin = fopen (argv[1], "rt");      
    if (yyin == NULL)     {        
      printf ("El fichero %s no se puede abrir\n", argv[1]);        
      exit (-1);      
    }    
  }    
else yyin = stdin;    
    
yylex ();    
escribir_autor();
escribir_titulo();
escribir_url(); 
return 0;  
} 
void escribir_datos (int dato1, int dato2, int dato3) { 
  printf  ("Num_caracteres=%d\tNum_palabras=%d\tNum_líneas=%d\n",dato1,dato2,dato3);   
} 

void escribir_autor(){ /*Esta función es para sacar al autor del articulo usando para ello, numeroToTalAutor que es la longitud de todo el texto que a coincidido con la regla y autor que es el texto que a coincidido*/
   for(int i=0;i<numeroTotalAutor;i++){/*como es html y en la pagina del pais cambian de un articulo a otro algunas cosas hay que contar que a los 3 <texto> aparece el nombre */
        if(autor[i]=='>'){
           contAutor++;}
        if(contAutor==3&&primeraVez==1){/*aqui guardo la longitud de la cadena hasta llegar al nombre*/
           tamanoAutor=i;primeraVez=0;} 
     } 

   for(int i=tamanoAutor;i<=numeroTotalAutor;i++){/*aqui a partir de la lomgitud cuando aparece el nombre empiezo a meter desde hasta el final del texto original y me sale el nombre.*/
       autorProcesado[i-(tamanoAutor+2)]=autor[i];
     }
printf("Autor: %s \n",autorProcesado);

}
void escribir_titulo(){
for(int i=33;i<=numeroTotalTitulo-4;i++){
       tituloProcesado[i-(34)]=titulo[i];
     }
printf("Titulo: %s \n",tituloProcesado);

}
void escribir_url(){
for(int i=34;i<=numeroTotalUrl;i++){
       urlProcesado[i-34]=url[i];
     }
printf("url: %s \n",urlProcesado);

}
