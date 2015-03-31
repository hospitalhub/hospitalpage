<?php

class DocumentTemplate
{

    /**
     *
     * @var unknown
     */
    const DIR = '/../build/docs/src/';

    /**
     *
     * @var unknown
     */
    static $documentFile;

    /**
     *
     * @var unknown
     */
    static $id = 0;

    /**
     *
     * @param unknown $title
     */
    function addChapter($title)
    {
        self::documentWrite("<div style=\"page-break-after: always;\"></div>");
        self::documentWrite("\n### " . $title);
        self::documentWrite("\n* * *\n");
    }

    /**
     *
     * @param unknown $content
     */
    function addNotice($file, $content)
    {
        self::documentWrite("<table><tr><td class=\"notice\">![achtung-kurwa]($file)</td><td>$content</td></tr></table>\n\n");
    }

    /**
     *
     * @param unknown $file
     * @param unknown $title
     * @param unknown $description
     */
    function addImg($file, $title, $description)
    {
        self::documentWrite("<table><tr><td class=\"tdimg\">![$title]($file) [" . (++ self::$id) . "]</td><td>$description</td></tr></table>\n\n");
    }

    /**
     */
    private function removeAllDocFiles()
    {
        foreach (glob(self::getDocDir() . "*") as $file) { // iterate files
            if (is_file($file))
                unlink($file); // delete file
        }
    }

    /**
     *
     * @return string
     */
    private function getFile()
    {
        if (self::$documentFile == null) {
            self::$documentFile = self::getDocDir() . 'puntion_' . date('YmdH') . '.md';
            self::removeAllDocFiles();
        }
        return self::$documentFile;
    }

    /**
     *
     * @param unknown $content
     */
    private function documentWrite($content)
    {
        $fp = fopen(self::getFile(), 'a+');
        fwrite($fp, $content);
        fclose($fp);
    }

    /**
     *
     * @return string
     */
    public static function getDocDir()
    {
        $path = __DIR__ . self::DIR;
        if (! file_exists($path)) {
            mkdir($path, 0777, true);
        }
        return $path;
    }
}
