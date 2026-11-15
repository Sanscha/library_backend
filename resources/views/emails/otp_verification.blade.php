<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SeatSync Verification Code</title>
</head>
<body style="margin: 0; padding: 0; background-color: #f4f5f7; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #1e293b;">
    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color: #f4f5f7; padding: 30px 15px;">
        <tr>
            <td align="center">
                <table role="presentation" width="100%" style="max-width: 520px; background-color: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.06);">
                    <!-- Header -->
                    <tr>
                        <td style="background-color: #0f1115; padding: 28px 32px; text-align: center;">
                            <span style="display: inline-block; background-color: #FF6B00; color: #ffffff; font-size: 20px; font-weight: 800; padding: 6px 14px; border-radius: 8px; letter-spacing: -0.5px;">SeatSync</span>
                            <h2 style="color: #ffffff; font-size: 20px; margin: 16px 0 0 0; font-weight: 700;">Verify Your Email Address</h2>
                        </td>
                    </tr>

                    <!-- Body -->
                    <tr>
                        <td style="padding: 32px 32px 20px 32px;">
                            <p style="margin: 0 0 16px 0; font-size: 15px; line-height: 24px; color: #475569;">
                                Hello,
                            </p>
                            <p style="margin: 0 0 24px 0; font-size: 15px; line-height: 24px; color: #475569;">
                                Use the 6-digit verification code below to complete your registration / login on SeatSync:
                            </p>

                            <!-- OTP Box -->
                            <div style="background-color: #f8fafc; border: 2px dashed #e2e8f0; border-radius: 12px; padding: 20px; text-align: center; margin: 0 0 24px 0;">
                                <span style="font-size: 34px; font-weight: 800; letter-spacing: 8px; color: #FF6B00; display: inline-block; font-family: monospace;">{{ $otp }}</span>
                            </div>

                            <p style="margin: 0 0 12px 0; font-size: 13px; color: #64748b; line-height: 20px;">
                                ⏱️ This code will expire in <strong>{{ $expiresInMinutes }} minutes</strong>.
                            </p>
                            <p style="margin: 0; font-size: 13px; color: #94a3b8; line-height: 20px;">
                                If you did not request this verification code, please ignore this email or contact support if you suspect unauthorized access.
                            </p>
                        </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td style="background-color: #f8fafc; padding: 20px 32px; border-top: 1px solid #e2e8f0; text-align: center;">
                            <p style="margin: 0; font-size: 12px; color: #94a3b8;">
                                &copy; {{ date('Y') }} SeatSync Library Management. All rights reserved.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
