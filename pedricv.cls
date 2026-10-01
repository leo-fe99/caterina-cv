% =============================================================================
%  pedricv.cls — minimal two-column curriculum vitae class (XeTeX / Tectonic)
%
%  Layout: white page, black type only. Two columns split by a thick vertical
%  rule; sections separated by thick horizontal bars that run up to it.
%  Left column: photo, name, profile, skills …; right column: experience.
%  Columns flow independently across pages thanks to `paracol`; anything
%  after \end{paracol} is set full width.
% =============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pedricv}[2026/10/01 Minimal two-column CV class]

\LoadClass[10pt]{article}

% ---------------------------------------------------------------- packages ---
\RequirePackage{fontspec}
\RequirePackage[italian]{babel}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{paracol}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{needspace}
\RequirePackage{ragged2e}
\RequirePackage[hidelinks]{hyperref}

% ------------------------------------------------------------------ colours --
\definecolor{ink}{HTML}{111111}    % text, bars and rules
\definecolor{muted}{HTML}{555555}  % dates and secondary text

% ------------------------------------------------------------------ layout ---
\RequirePackage[
  a4paper,
  left=16mm, right=16mm,
  top=15mm, bottom=14mm,
]{geometry}

\setlength\columnsep{12mm}
\columnratio{0.51}

\newlength\cv@barwd   \setlength\cv@barwd{2.4pt}  % horizontal bars + vertical rule
\newlength\cv@barout  \setlength\cv@barout{2.5mm} % bar overhang past the text edge

\setlength\columnseprule{\cv@barwd}
\colseprulecolor{ink}

\setlength\parindent{0pt}
\setlength\parskip{0pt}
\frenchspacing
\pagestyle{empty}

% -------------------------------------------------------------------- fonts --
\defaultfontfeatures{Ligatures=TeX, Numbers=Lining}

\setmainfont{Montserrat}[
  Extension      = .otf,
  UprightFont    = *-Regular,
  ItalicFont     = *-Italic,
  BoldFont       = *-SemiBold,
  BoldItalicFont = *-SemiBoldItalic,
]
\setsansfont{Montserrat}[
  Extension      = .otf,
  UprightFont    = *-Regular,
  ItalicFont     = *-Italic,
  BoldFont       = *-SemiBold,
  BoldItalicFont = *-SemiBoldItalic,
]
\newfontfamily\cv@namefont{Montserrat}[
  Extension = .otf, UprightFont = *-Bold, LetterSpace = 8]
\newfontfamily\cv@headingfont{Montserrat}[
  Extension = .otf, UprightFont = *-Bold, LetterSpace = 8]
\newfontfamily\cv@mediumfont{Montserrat}[
  Extension = .otf, UprightFont = *-Medium]
\newfontfamily\cv@boldfont{Montserrat}[
  Extension = .otf, UprightFont = *-Bold]

\renewcommand\normalsize{\@setfontsize\normalsize{8.6pt}{12pt}}
\renewcommand\small{\@setfontsize\small{7.8pt}{11pt}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{7pt}{9.6pt}}
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

% ----------------------------------------------------------- personal data ---
% \cvset{key}{value} stores a field; empty fields are simply not printed.
\newcommand\cvset[2]{\csdef{cv@field@#1}{#2}}
\newcommand\cvget[1]{\csuse{cv@field@#1}}
\newcommand\cvifset[2]{\ifcsempty{cv@field@#1}{}{#2}}
\cvset{firstname}{}\cvset{lastname}{}\cvset{title}{}\cvset{photo}{}
\cvset{email}{}\cvset{phone}{}\cvset{linkedin}{}\cvset{website}{}

% ----------------------------------------------------------------- headings --
% Track whether we are inside paracol, so bars know which way to extend.
\newif\ifcv@incols
\AtBeginEnvironment{paracol}{\global\cv@incolstrue}
\AtEndEnvironment{paracol}{\global\cv@incolsfalse}

% Thick bar across the column: overhangs the outer text edge slightly and
% runs to the vertical rule on the inner side, as one continuous grid.
% Drawn as leaders (i.e. glue), so it is discarded at the top of a column.
\newcommand\cv@bar{%
  \ifcv@incols
    \ifnum\pcol@currcol=\z@
      \cv@barline{\cv@barout}{\dimexpr0.5\columnsep\relax}%
    \else
      \cv@barline{\dimexpr0.5\columnsep\relax}{\cv@barout}%
    \fi
  \else
    \cv@barline{\cv@barout}{\cv@barout}%
  \fi}
\newcommand\cv@barline[2]{%
  \par
  \cleaders\hbox to\linewidth{\hspace*{-#1}%
    \vrule width\dimexpr\linewidth+#1+#2\relax height\cv@barwd depth\z@\hss}%
  \vskip\cv@barwd}

% \cvsection{Title} — bar, then heading.  \cvsection*{Title} — never a bar.
\newlength\cv@sectionskip \setlength\cv@sectionskip{4mm}
\newif\ifcv@afterheading    % an entry right below a heading adds no top space
\newcommand\cvsection{\@ifstar{\cv@section\@empty}{\cv@section\cv@bar}}
\newcommand\cv@section[2]{%
  \par\Needspace*{6\baselineskip}%
  \ifx#1\@empty\else
    \addvspace{\cv@sectionskip}#1\nobreak\vspace{\cv@sectionskip}%
  \fi
  {\cv@headingfont\fontsize{10.5pt}{12pt}\selectfont\MakeUppercase{#2}\par}%
  \nobreak\vspace{2.6mm}\nobreak\@afterheading
  \global\cv@afterheadingtrue}

% ------------------------------------------------------------------- header --
% Rectangular portrait (native 3:4 aspect), no frame, centred in the left
% column's cell — between where the bars start and the vertical rule.
\newcommand\cvphoto{%
  \cvifset{photo}{%
    \makebox[\linewidth]{\hspace{\dimexpr0.5\columnsep-\cv@barout\relax}%
      \includegraphics[width=0.55\linewidth]{\cvget{photo}}}\par
    \vspace{4mm}}}

% Name on two lines, title below
\newcommand\cvheader{%
  {\cv@namefont\fontsize{26pt}{29pt}\selectfont
    \MakeUppercase{\cvget{firstname}}\par
    \MakeUppercase{\cvget{lastname}}\par}%
  \cvifset{title}{%
    \vspace{2.4mm}%
    {\cv@mediumfont\fontsize{10pt}{13pt}\selectfont\cvget{title}\par}}}

% -------------------------------------------------------------------- links --
% \cvlink{url}{text} — hyperlink with a thin underline at a fixed depth
\newcommand\cv@ul[1]{%
  \leavevmode\sbox0{#1}%
  \rlap{\rule[-1.6pt]{\wd0}{0.45pt}}\usebox0}
\newcommand\cvlink[2]{\href{#1}{\cv@ul{#2}}}

% ------------------------------------------------------------- label lines --
% \cvlabel{Label}{text} — run-in semibold label (skills, other info, contacts)
\newcommand\cvlabel[2]{%
  {\RaggedRight\textbf{#1:}\space#2\par}\vspace{1.1mm}}

\newcommand\cvcontacts{%
  \cvifset{email}{\cvlabel{Email}{\cvlink{mailto:\cvget{email}}{\cvget{email}}}}%
  \cvifset{phone}{\cvlabel{Telefono}{\cvget{phone}}}%
  \cvifset{linkedin}{\cvlabel{LinkedIn}{%
    \cvlink{https://www.linkedin.com/in/\cvget{linkedin}}%
            {linkedin.com/in/\cvget{linkedin}}}}%
  \cvifset{website}{\cvlabel{Sito}{%
    \cvlink{https://\cvget{website}}{\cvget{website}}}}}

% ----------------------------------------------------------------- entries --
% \cventry{Role}{Dates}{Organisation — Place}
% Dates sit right-aligned on the role line; when the role is too long they
% move to the organisation line, or below it. An entry's header is never left
% alone at the foot of a page.
\newcommand\cv@rolefont{\cv@boldfont\fontsize{9.2pt}{11.5pt}\selectfont}
\newcommand\cventry[3]{%
  \par
  \ifcv@afterheading \global\cv@afterheadingfalse
  \else \Needspace*{5\baselineskip}\addvspace{4mm}\fi
  \sbox0{\cv@rolefont#1}\sbox2{\small\color{muted}#2}\sbox4{\cv@mediumfont#3}%
  \ifdim\dimexpr\wd0+\wd2+4mm\relax>\linewidth
    \usebox0\par\nobreak\vspace{0.8mm}%
    \ifdim\dimexpr\wd4+\wd2+4mm\relax>\linewidth
      {\RaggedRight\cv@mediumfont#3\par}\nobreak\vspace{0.4mm}\usebox2\par
    \else
      \hbox to\linewidth{\usebox4\hfill\usebox2}%
    \fi
  \else
    \hbox to\linewidth{\usebox0\hfill\usebox2}%
    \nobreak\vspace{0.8mm}%
    {\RaggedRight\cv@mediumfont#3\par}%
  \fi
  \nobreak\vspace{1.6mm}}

% \cvcert{Title}{Place, date}{Detail} — one item inside a cvitems list
\newcommand\cvcert[3]{%
  \item{\textbf{#1}\par}%
  {\small\color{muted}#2\par}%
  \ifblank{#3}{}{#3\par}}

% Short context line under an entry; never split across pages
\newcommand\cvdesc[1]{{\RaggedRight\interlinepenalty=10000 #1\par}\vspace{1mm}}

% Bullet lists
\newcommand\cv@bullet{\raisebox{-0.12ex}{\scalebox{1.5}{\textbullet}}}
\newlist{cvitems}{itemize}{1}
\setlist[cvitems]{
  label=\cv@bullet, leftmargin=3.6mm, labelsep=2mm,
  itemsep=0.8mm, parsep=0pt, topsep=0.8mm, partopsep=0pt,
  before=\RaggedRight}

% Prose paragraphs (profile, about me), justified as in the reference
\newenvironment{cvprose}
  {\par\setlength\parskip{2mm}\justifying
   \hyphenpenalty=1500 \emergencystretch=1em\relax}
  {\par}

% Privacy consent (customary on Italian CVs), printed where \cvprivacyline is
% placed — normally the very end of the document.
\newcommand\cv@privacy{}
\newcommand\cvprivacy[1]{\renewcommand\cv@privacy{#1}}
\newcommand\cvprivacyline{%
  \ifdefempty{\cv@privacy}{}{%
    \par\vspace{8mm}%
    {\footnotesize\itshape\color{muted}\RaggedRight\cv@privacy\par}}}

% --------------------------------------------------------------- metadata ----
\newcommand\cvmetadata[1]{%
  \hypersetup{
    pdfauthor   = {\cvget{firstname} \cvget{lastname}},
    pdftitle    = {\cvget{firstname} \cvget{lastname} – Curriculum Vitae},
    pdfsubject  = {\cvget{title}},
    pdfkeywords = {#1},
    pdflang     = {it-IT},
    pdfdisplaydoctitle = true,
    pdfcreator  = {LaTeX (Tectonic) – pedricv.cls},
  }}

\endinput
