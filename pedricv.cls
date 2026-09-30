% =============================================================================
%  pedricv.cls — two-column curriculum vitae class (XeTeX / Tectonic)
%
%  Layout: warm sidebar on the left (photo, contacts, skills, education …),
%  main column on the right (header, profile, experience …). Columns flow
%  independently across pages thanks to `paracol`.
% =============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pedricv}[2026/09/30 Two-column CV class]

\LoadClass[10pt]{article}

% ---------------------------------------------------------------- packages ---
\RequirePackage{fontspec}
\RequirePackage[italian]{babel}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{eso-pic}
\RequirePackage{paracol}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{needspace}
\RequirePackage{ragged2e}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{refcount}
\RequirePackage{fontawesome5}
\RequirePackage[hidelinks]{hyperref}

% ------------------------------------------------------------------ layout ---
% Sidebar band: 0 → \cv@sidebarwd from the left paper edge.
% Sidebar text: \cv@sidepad inside the band on both sides.
\newlength\cv@sidebarwd  \setlength\cv@sidebarwd{68mm}
\newlength\cv@sidepad    \setlength\cv@sidepad{9mm}
\newlength\cv@mainpad    \setlength\cv@mainpad{10mm}

\RequirePackage[
  a4paper,
  left=9mm, right=12mm,
  top=13mm, bottom=16mm,
  footskip=8.5mm,
]{geometry}

\newlength\cv@sidewd
\newlength\cv@maingap
\newlength\cv@mainwd
\setlength\cv@sidewd{\dimexpr\cv@sidebarwd-2\cv@sidepad\relax}
\setlength\cv@maingap{\dimexpr\cv@sidepad+\cv@mainpad\relax}
\setlength\cv@mainwd{\dimexpr\textwidth-\cv@sidewd-\cv@maingap\relax}

\setcolumnwidth{\cv@sidewd/\cv@maingap,\cv@mainwd}

\setlength\parindent{0pt}
\setlength\parskip{0pt}
\frenchspacing
\pagestyle{empty}

% ------------------------------------------------------------------ colours --
\definecolor{accent}{HTML}{175E5C}   % deep teal
\definecolor{ink}{HTML}{1F2A2C}      % primary text
\definecolor{muted}{HTML}{5B6769}    % secondary text
\definecolor{faint}{HTML}{8E9A9B}    % tertiary text
\definecolor{sidebar}{HTML}{F4EFE8}  % warm sand
\definecolor{rule}{HTML}{D6CEC2}     % hairlines

% -------------------------------------------------------------------- fonts --
\defaultfontfeatures{Ligatures=TeX, Numbers=Lining}

\setmainfont{SourceSansPro}[
  Extension      = .otf,
  UprightFont    = *-Regular,
  ItalicFont     = *-RegularIt,
  BoldFont       = *-Semibold,
  BoldItalicFont = *-SemiboldIt,
]
\setsansfont{SourceSansPro}[
  Extension      = .otf,
  UprightFont    = *-Regular,
  ItalicFont     = *-RegularIt,
  BoldFont       = *-Semibold,
  BoldItalicFont = *-SemiboldIt,
]
\newfontfamily\cv@lightfont{SourceSansPro}[
  Extension = .otf, UprightFont = *-Light, ItalicFont = *-LightIt]
\newfontfamily\cv@displaylight{Montserrat}[
  Extension = .otf, UprightFont = *-Light, LetterSpace = 6]
\newfontfamily\cv@displaybold{Montserrat}[
  Extension = .otf, UprightFont = *-SemiBold, LetterSpace = 6]
\newfontfamily\cv@headingfont{Montserrat}[
  Extension = .otf, UprightFont = *-SemiBold, LetterSpace = 10]
\newfontfamily\cv@rolefont{Montserrat}[
  Extension = .otf, UprightFont = *-SemiBold]

\renewcommand\normalsize{\@setfontsize\normalsize{9.5pt}{12.2pt}}
\renewcommand\small{\@setfontsize\small{8.8pt}{11.2pt}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{8pt}{10.2pt}}
\normalsize
\AtBeginDocument{\color{ink}}

% Italian typographic hyphenation for narrow columns
\hyphenpenalty=600
\exhyphenpenalty=600
\finalhyphendemerits=100000   % never leave a word fragment alone on the last line
\RaggedRightParindent=0pt
\setlength\RaggedRightRightskip{0pt plus 4em}
\AtBeginDocument{\righthyphenmin=3 }
\JustifyingParindent=0pt

% ------------------------------------------------------------------- footer --
\fancypagestyle{cv}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \fancyfoot[R]{\footnotesize\color{faint}%
    \cv@name\enspace·\enspace Curriculum Vitae\enspace·\enspace
    \thepage\,/\,\pageref*{LastPage}}%
}
\AtBeginDocument{\pagestyle{cv}}

% ------------------------------------------------------- sidebar background --
\AddToShipoutPictureBG{%
  \AtPageLowerLeft{\color{sidebar}\rule{\cv@sidebarwd}{\paperheight}}}

% Privacy consent at the foot of the sidebar on the last page, its last
% baseline level with the page-number footer.
\AddToShipoutPictureFG{%
  \ifdefempty{\cv@privacy}{}{%
    \ifnum\value{page}=\getpagerefnumber{LastPage}\relax
      \AtPageLowerLeft{%
        \put(\LenToUnit{\cv@sidepad},
             \LenToUnit{\dimexpr\Gm@bmargin-\footskip\relax}){%
          \parbox[b]{\cv@sidewd}{\footnotesize\itshape\color{faint}%
            \RaggedRight\cv@privacy}}}%
    \fi}}

% ----------------------------------------------------------- personal data ---
% \cvset{key}{value} stores a field; empty fields are simply not printed.
\newcommand\cvset[2]{\csdef{cv@field@#1}{#2}}
\newcommand\cvget[1]{\csuse{cv@field@#1}}
\newcommand\cvifset[2]{\ifcsempty{cv@field@#1}{}{#2}}
\cvset{firstname}{}\cvset{lastname}{}\cvset{title}{}\cvset{subtitle}{}
\cvset{email}{}\cvset{phone}{}\cvset{location}{}
\cvset{linkedin}{}\cvset{website}{}\cvset{photo}{}\cvset{availability}{}
\newcommand\cv@name{\cvget{firstname}~\cvget{lastname}}

% ----------------------------------------------------------------- headings --
\newlength\cvsectionskip \setlength\cvsectionskip{5mm}

\newcommand\cvsection[1]{%
  \par\Needspace*{5\baselineskip}%
  \addvspace{\cvsectionskip}%
  \hbox to \linewidth{%
    {\cv@headingfont\fontsize{8.4pt}{10pt}\selectfont\color{accent}%
     \MakeUppercase{#1}}%
    \hskip 2.5mm%
    {\color{rule}\leaders\vrule height 3.1pt depth -2.5pt\hfill}}%
  \par\nobreak\vspace{2.4mm}\nobreak\@afterheading}

% ------------------------------------------------------------------- header --
\newlength\cv@headerht \setlength\cv@headerht{41mm}

% Circular photo, sized to the sidebar width
\newcommand\cvphoto{%
  \cvifset{photo}{%
    \hbox to \linewidth{\hss
      \begin{tikzpicture}
        \useasboundingbox (-20.5mm,-20.5mm) rectangle (20.5mm,20.5mm);
        \begin{scope}
          \clip (0,0) circle (18.8mm);
          \node[inner sep=0pt] at (0,0)
            {\includegraphics[width=37.8mm]{\cvget{photo}}};
        \end{scope}
        \draw[white, line width=2.2pt] (0,0) circle (18.8mm);
        \draw[accent, line width=0.7pt] (0,0) circle (20.1mm);
      \end{tikzpicture}%
    \hss}%
    \par}}

% Name, title and availability badge; same height as the photo so both align
\newcommand\cvheader{%
  \vbox to \cv@headerht{\vss
    {\cv@displaylight\fontsize{27pt}{30pt}\selectfont\color{ink}%
      \MakeUppercase{\cvget{firstname}}\par}%
    {\cv@displaybold\fontsize{27pt}{31pt}\selectfont\color{accent}%
      \MakeUppercase{\cvget{lastname}}\par}%
    \vspace{3.2mm}%
    {\fontsize{12pt}{15pt}\selectfont
      \textbf{\cvget{title}}%
      \cvifset{subtitle}{%
        {\color{rule}\enspace|\enspace}{\color{muted}\cvget{subtitle}}}\par}%
    \cvifset{availability}{%
      \vspace{3.4mm}%
      \tikz[baseline=(b.base)]\node[
        fill=accent!9, text=accent, rounded corners=7pt,
        inner xsep=7pt, inner ysep=3.2pt](b)
        {\small\raisebox{0.15ex}{\tiny\faCircle}\enspace\cvget{availability}};\par}%
  \vss}\par}

% ------------------------------------------------------------ sidebar parts --
\newcommand\cv@iconrow[2]{%
  \hangindent=5.5mm\hangafter=1
  \makebox[5.5mm][l]{\color{accent}\small#1}#2\par\vspace{1.3mm}}

\newcommand\cvcontacts{%
  \cvifset{email}{\cv@iconrow{\faEnvelope[regular]}{%
    \href{mailto:\cvget{email}}{\cvget{email}}}}%
  \cvifset{phone}{\cv@iconrow{\faPhone*}{\cvget{phone}}}%
  \cvifset{location}{\cv@iconrow{\faMapMarker*}{\cvget{location}}}%
  \cvifset{linkedin}{\cv@iconrow{\faLinkedinIn}{%
    \href{https://www.linkedin.com/in/\cvget{linkedin}}{in/\cvget{linkedin}}}}%
  \cvifset{website}{\cv@iconrow{\faGlobeEurope}{%
    \href{https://\cvget{website}}{\cvget{website}}}}}

\newcommand\cvhascontacts{%
  \ifboolexpr{
    test {\ifcsempty{cv@field@email}}    and test {\ifcsempty{cv@field@phone}} and
    test {\ifcsempty{cv@field@location}} and test {\ifcsempty{cv@field@linkedin}} and
    test {\ifcsempty{cv@field@website}}}{\@secondoftwo}{\@firstoftwo}}

% \cvlanguage{Language}{Level}
\newcommand\cvlanguage[2]{%
  \hbox to \linewidth{\textbf{#1}\hfill{\color{muted}#2}}\vspace{1mm}}

% \cvcert{Title}{Date}
\newcommand\cvcert[2]{%
  {\RaggedRight\textbf{#1}\par}%
  \ifblank{#2}{}{{\small\color{muted}#2\par}}%
  \vspace{2.2mm}}

% \cvdegree{Degree}{Institution}{Dates}{Grade}
\newcommand\cvdegree[4]{%
  {\RaggedRight
   {\cv@rolefont\fontsize{9.6pt}{12pt}\selectfont #1\par}\vspace{0.6mm}
   {\color{accent}\textbf{#2}}\par
   {\small\color{muted}#3\par}}%
  \ifblank{#4}{}{%
    \vspace{1.6mm}%
    \tikz[baseline=(g.base)]\node[
      draw=accent, text=accent, rounded corners=6pt, line width=0.5pt,
      inner xsep=6pt, inner ysep=2.4pt](g){\small\faAward\enspace\textbf{#4}};\par}}

% --------------------------------------------------------------- main parts --
% \cventry{Role}{Dates}{Organisation}{Place}
% An entry may continue on the next page, but its header is never left
% alone at the bottom of a page.
\newcommand\cventry[4]{%
  \par\Needspace*{5\baselineskip}%
  \addvspace{3mm}%
  \hbox to \linewidth{%
    {\cv@rolefont\fontsize{10.2pt}{12.5pt}\selectfont\color{ink}#1}%
    \hfill{\small\color{muted}#2}}%
  \vspace{0.5mm}%
  {\RaggedRight{\color{accent}\textbf{#3}}%
   \ifblank{#4}{}{{\color{faint}\enspace·\enspace}{\color{muted}#4}}\par}%
  \vspace{1mm}}

% Short context line under an entry
\newcommand\cvdesc[1]{{\RaggedRight\color{muted}#1\par}\vspace{0.8mm}}

% Emphasis inside running text
\newcommand\hl[1]{\textbf{#1}}
\newcommand\hlaccent[1]{{\color{accent}\textbf{#1}}}

% Bullet lists
\newcommand\cv@bullet{%
  \raisebox{0.28ex}{\tikz\fill[accent] (0,0) circle (0.95pt);}}
\newlist{cvitems}{itemize}{1}
\setlist[cvitems]{
  label=\cv@bullet, leftmargin=3.6mm, labelsep=2mm,
  itemsep=0.6mm, parsep=0pt, topsep=0.6mm, partopsep=0pt,
  before=\RaggedRight}

% Prose paragraphs (profile, about me)
\newenvironment{cvprose}
  {\par\setlength\parskip{1.2mm}\RaggedRight}
  {\par}

% Privacy consent (customary on Italian CVs): printed at the foot of the
% sidebar on the last page — see the footer definition above.
\newcommand\cv@privacy{}
\newcommand\cvprivacy[1]{\renewcommand\cv@privacy{#1}}

% --------------------------------------------------------------- metadata ----
\newcommand\cvmetadata[1]{%
  \hypersetup{
    pdfauthor   = {\cvget{firstname} \cvget{lastname}},
    pdftitle    = {\cvget{firstname} \cvget{lastname} – Curriculum Vitae},
    pdfsubject  = {\cvget{title} – \cvget{subtitle}},
    pdfkeywords = {#1},
    pdflang     = {it-IT},
    pdfdisplaydoctitle = true,
    pdfcreator  = {LaTeX (Tectonic) – pedricv.cls},
  }}

\endinput
